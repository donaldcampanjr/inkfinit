#!/usr/bin/env bash
set -e
npm ci
npm run build
/usr/bin/rsync -avz --delete --perms --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r \
--exclude='.git' --exclude='.github' --exclude='node_modules' --exclude='.env' \
-e 'ssh -p 18765' dist/ \
u2050-grkr3li1rvfx@ssh.inkfinit.com:/home/customer/www/staging.inkfinit.com/public_html/
