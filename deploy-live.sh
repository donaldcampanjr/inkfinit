#!/usr/bin/env bash
set -e
ssh -p 18765 u2050-grkr3li1rvfx@ssh.inkfinit.com \
'rsync -a --delete --exclude=".htaccess" \
/home/customer/www/staging.inkfinit.com/public_html/ \
/home/customer/www/inkfinit.com/public_html/'
