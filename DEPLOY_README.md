# Inkfinit Deployment Guide

## Environments
Branch | Domain | Purpose
-------|---------|---------
dev | https://staging.inkfinit.com | Staging / testing
main | https://inkfinit.com | Live production

## Local Deployment
- ./deploy-staging.sh — build and upload to staging  
- ./deploy-live.sh — promote staging → live

## Automatic Deploy (GitHub Actions)
- Push or PR to dev → deploys to staging  
- Push or merge to main → deploys to live

## Setup
Add repository secret SSH_PRIVATE_KEY with your SiteGround private key.  
Workflow file: .github/workflows/deploy.yml

## SiteGround
Keep Dynamic Cache OFF for staging.  
Optionally enable cache for live after deploy.

## Manual Verification
npm run build  
./deploy-staging.sh  
./deploy-live.sh  
curl -s -L https://staging.inkfinit.com | grep title  
curl -s -L https://inkfinit.com | grep title  
