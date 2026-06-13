#!/usr/bin/env bash
set -euo pipefail

echo "OpenShop - EC2 Instance Setup"
echo "=============================="

# Update system
sudo apt-get update
sudo apt-get upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Docker
sudo apt-get install -y docker.io

# Add current user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install PM2 globally
sudo npm install -g pm2

# Create app directory
mkdir -p /home/ubuntu/shop
cd /home/ubuntu/shop

echo "Setup complete. Ready for deployment."
echo "Next steps:"
echo "1. Copy your .env.production file with DATABASE_URL"
echo "2. Run: docker-compose up -d"
echo "Or for PM2 deployment:"
echo "3. Run: npm install --production && npm start"
