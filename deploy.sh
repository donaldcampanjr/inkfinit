#!/bin/bash
set -e

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
BUG_ID="bug-$(date +%Y%m%d-%H%M%S)"
SSH_USER="u2050-grkr3li1rvfx"
SSH_HOST="ssh.inkfinit.com"
SSH_PORT=18765

LIVE_PATH="/home/customer/www/inkfinit.com/public_html"
STAGING_PATH="/home/customer/www/staging.inkfinit.com/public_html"
LOG_PATH="/home/customer/www/inkfinit.com/public_html/logs"

if [ "$CURRENT_BRANCH" = "dev" ]; then
  TARGET="$STAGING_PATH"
  SITE_URL="https://staging.inkfinit.com"
else
  TARGET="$LIVE_PATH"
  SITE_URL="https://inkfinit.com"
fi

echo "⚙️  Building locally for '$CURRENT_BRANCH'..."
npm run build || npm exec vite build

echo "🚀 Uploading → $SSH_HOST:$TARGET"
ssh -T -p $SSH_PORT -o StrictHostKeyChecking=no $SSH_USER@$SSH_HOST <<EOSSH
  mkdir -p "$TARGET" "$LOG_PATH" || true
  touch "$LOG_PATH/deploy.log"
EOSSH

rsync -rltgoDzvO --delete -e "ssh -p $SSH_PORT -o StrictHostKeyChecking=no" dist/ $SSH_USER@$SSH_HOST:"$TARGET/"

ssh -T -p $SSH_PORT -o StrictHostKeyChecking=no $SSH_USER@$SSH_HOST <<EOSSH
  find "$TARGET" -type f -exec chmod 644 {} \;
  find "$TARGET" -type d -exec chmod 755 {} \;
  echo "[$CURRENT_BRANCH] Deploy OK $(date)" >> "$LOG_PATH/deploy.log"
EOSSH

echo "✅ Deployment complete for '$CURRENT_BRANCH'"
echo "📜 Log ID: $BUG_ID"
open "$SITE_URL"
