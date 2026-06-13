#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Build frontend assets
cd Frontend
npm install
npm run build
cd "$SCRIPT_DIR"

# Sync source and build to target EC2 instance
if [ -z "${EC2_HOST:-}" ] || [ -z "${EC2_USER:-}" ] || [ -z "${SSH_KEY_PATH:-}" ]; then
  echo "ERROR: EC2_HOST, EC2_USER, and SSH_KEY_PATH environment variables must be set."
  exit 1
fi

scp -i "$SSH_KEY_PATH" -r Frontend/server Frontend/dist Frontend/package.json Frontend/package-lock.json "$EC2_USER@$EC2_HOST:/home/$EC2_USER/shop"
ssh -i "$SSH_KEY_PATH" "$EC2_USER@$EC2_HOST" "cd /home/$EC2_USER/shop && npm install --production && pm2 restart shop || pm2 start --name shop npm -- start"
