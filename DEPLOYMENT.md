# OpenShop Production Deployment Guide

## ✅ CLI Tools Status

Both `gh` and `aws` are now configured and working:

### GitHub CLI (gh)
- **Path:** `./dev-tools/gh/bin/gh.exe` 
- **Version:** 2.94.0
- **Status:** ✅ Installed and working

### AWS CLI (aws)
- **Path:** `C:\Users\user\AppData\Roaming\Python\Python313\Scripts\aws.cmd`
- **Alternative:** `C:/Python313/python.exe -m awscli`
- **Version:** 1.45.29
- **Status:** ✅ Installed and working

---

## Quick Start - Using CLI Tools

### Option 1: Load Tools in Current Session
```powershell
# Run this to add gh and aws to PATH
.\start-env.ps1
# or in CMD:
.\start-env.bat
```

### Option 2: Use Full Paths
```powershell
# GitHub CLI
.\dev-tools\gh\bin\gh.exe --version

# AWS CLI
C:/Python313/python.exe -m awscli --version
```

---

## Production Deployment Setup

### Step 1: Build Frontend Locally
```bash
cd Frontend
npm install
npm run build
```

### Step 2: Push to GitHub
```powershell
# Using local gh
.\dev-tools\gh\bin\gh.exe auth login

git add .
git commit -m "Add production deployment files"
git push origin main
```

### Step 3: Configure GitHub Secrets
Use GitHub web interface or gh CLI:

```powershell
.\dev-tools\gh\bin\gh.exe secret set EC2_HOST --body "your-ec2-ip-or-hostname"
.\dev-tools\gh\bin\gh.exe secret set EC2_USER --body "ubuntu"
.\dev-tools\gh\bin\gh.exe secret set EC2_SSH_PRIVATE_KEY --body @"your-private-key-path"
.\dev-tools\gh\bin\gh.exe secret set EC2_DATABASE_URL --body "postgresql://user:pass@host/db?sslmode=require"
```

### Step 4: Setup EC2 Instance (One-time)
```bash
# On your local machine
scp scripts/setup-ec2.sh ubuntu@<EC2_IP>:/home/ubuntu/

# SSH into EC2
ssh -i your-key.pem ubuntu@<EC2_IP>
bash /home/ubuntu/setup-ec2.sh
```

### Step 5: Deploy
Push to main branch and GitHub Actions will automatically build and deploy:
```bash
git push origin main
```

---

## Docker Production Environment

### Files Included
- `Dockerfile` - Production container definition
- `docker-compose.yml` - Service orchestration
- `.dockerignore` - Build optimization

### Manual Docker Deployment
```bash
# Build
docker build -t shop:latest .

# Run
docker run -p 4001:4001 -e DATABASE_URL="postgresql://..." shop:latest

# Or with Docker Compose
docker-compose up -d
```

---

## Application Architecture

```
┌─────────────────────────────────────┐
│      Browser (Frontend UI)          │
└──────────────┬──────────────────────┘
               │ HTTP/REST
┌──────────────▼──────────────────────┐
│       Express.js Server (4001)      │
├──────────────────────────────────────┤
│  ✓ Static files from dist/          │
│  ✓ /api/* routes (Products, Auth)   │
│  ✓ /health endpoint (health check)  │
│  ✓ /images/* (product images)       │
│  ✓ SPA fallback routing             │
└──────────────┬──────────────────────┘
               │ PostgreSQL
┌──────────────▼──────────────────────┐
│   PostgreSQL Database (Neon/RDS)    │
└─────────────────────────────────────┘
```

---

## Environment Variables

### Production (.env.production)
```env
DATABASE_URL=postgresql://user:pass@prod-db-host/dbname?sslmode=require
NODE_ENV=production
PORT=4001
```

### Development (.env)
```env
DATABASE_URL=postgresql://user:pass@localhost/neondb?sslmode=require
NODE_ENV=development
PORT=4001
```

---

## Verification

### Test Deployment Locally
```bash
cd Frontend
npm install
npm run build

# Start production server
NODE_ENV=production npm start
```

Visit: `http://localhost:4001`

### Test with Docker
```bash
docker-compose up

# In another terminal
curl http://localhost:4001/health
```

---

## AWS CLI Usage Examples

### Configure AWS Credentials
```powershell
C:/Python313/python.exe -m awscli configure
# Or with local python
aws configure
```

### Deploy/Manage EC2
```powershell
# List instances
C:/Python313/python.exe -m awscli ec2 describe-instances

# Get instance status
C:/Python313/python.exe -m awscli ec2 describe-instance-status --instance-ids i-xxxxxxxx

# Create security group
C:/Python313/python.exe -m awscli ec2 create-security-group --group-name shop-sg --description "OpenShop"
```

---

## GitHub CLI Usage Examples

### Repository Management
```powershell
# Create repo
.\dev-tools\gh\bin\gh.exe repo create

# View repo info
.\dev-tools\gh\bin\gh.exe repo view

# List pull requests
.\dev-tools\gh\bin\gh.exe pr list
```

### Secrets Management
```powershell
# Set secret
.\dev-tools\gh\bin\gh.exe secret set MY_SECRET --body "value"

# List secrets
.\dev-tools\gh\bin\gh.exe secret list

# Remove secret
.\dev-tools\gh\bin\gh.exe secret delete MY_SECRET
```

---

## Troubleshooting

### Health Check Fails
```bash
curl -v http://localhost:4001/health
# Should return: {"status":"ok"}
```

### Frontend Not Loading
```bash
# Check if dist/ folder exists
ls -la Frontend/dist/

# Verify static files served
curl http://localhost:4001/
```

### Database Connection Error
```bash
# Check DATABASE_URL is set
echo $DATABASE_URL

# Test connection locally
psql $DATABASE_URL -c "SELECT 1"
```

### gh/aws Commands Not Found
```powershell
# Reload environment
.\start-env.ps1

# Verify paths
.\dev-tools\gh\bin\gh.exe --version
C:/Python313/python.exe -m awscli --version
```

---

## Deployment Checklist

- [ ] Frontend builds successfully: `npm run build`
- [ ] `.env.production` file created with `DATABASE_URL`
- [ ] EC2 instance setup complete with Docker
- [ ] GitHub secrets configured (EC2_HOST, EC2_USER, EC2_SSH_PRIVATE_KEY, EC2_DATABASE_URL)
- [ ] GitHub repo initialized: `git push origin main`
- [ ] Health endpoint responding: `curl https://your-domain/health`
- [ ] Frontend loads: Visit `https://your-domain`
- [ ] API endpoints working: Test at least one `/api/` endpoint

---

## Support

For deployment issues:
1. Check GitHub Actions logs
2. SSH into EC2 and check Docker logs: `docker-compose logs`
3. Verify database connectivity
4. Check security group rules allow port 4001
