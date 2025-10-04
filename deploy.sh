#!/bin/bash
set -e

# === CONFIG ===
SSH_HOST="ssh.inkfinit.com"
SSH_PORT="18765"
SSH_USER="u2050-grkr3li1rvfx"
LIVE_PATH="/home/customer/www/inkfinit.com/public_html"
STAGING_PATH="/home/customer/www/staging.inkfinit.com/public_html"
LOG_PATH="/home/customer/www/inkfinit.com/logs"
BRANCH=${1:-$(git rev-parse --abbrev-ref HEAD)}
BUG_ID="bug-$(date +%Y%m%d-%H%M%S)"

# === DETERMINE TARGET ===
if [ "$BRANCH" = "dev" ]; then
  TARGET="$STAGING_PATH"
  SITE_URL="https://staging.inkfinit.com"
  echo "🧪 Deploying STAGING build (branch: dev)"
else
  TARGET="$LIVE_PATH"
  SITE_URL="https://inkfinit.com"
  echo "🚀 Deploying LIVE build (branch: $BRANCH)"
fi

# === BUILD LOCALLY ===
echo "⚙️  Building locally for '$BRANCH'..."
npm run build || (echo "❌ Build failed" && exit 1)

# === Ensure remote dirs exist ===
ssh -T -p $SSH_PORT -o StrictHostKeyChecking=no $SSH_USER@$SSH_HOST <<EOSSH
  mkdir -p "$TARGET" "$LOG_PATH"
  touch "$LOG_PATH/deploy.log"
EOSSH

# === Upload built files ===
echo "📦 Uploading to $SSH_HOST:$TARGET"
rsync -rltgoDzvO --delete -e "ssh -p $SSH_PORT -o StrictHostKeyChecking=no" dist/ $SSH_USER@$SSH_HOST:"$TARGET/"

# === Set permissions + log ===
ssh -T -p $SSH_PORT -o StrictHostKeyChecking=no $SSH_USER@$SSH_HOST <<EOSSH
  find "$TARGET" -type f -exec chmod 644 {} \;
  find "$TARGET" -type d -exec chmod 755 {} \;
  echo "[$BRANCH] Deploy successful → $TARGET at \$(date)" >> "$LOG_PATH/deploy.log"
EOSSH

echo "✅ Deployment complete for '$BRANCH'"
echo "🔗 $SITE_URL"
open "$SITE_URL"
