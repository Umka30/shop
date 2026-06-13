# Deployment Setup

## Prerequisites
- `git` installed
- `gh` available in PATH or via `.dev-tools/bin/gh.exe`
- `aws` available via Python user install at `%APPDATA%\Python\Python313\Scripts\aws.cmd`
- `ssh` and `scp` available
- `pm2` installed on the EC2 instance
- AWS EC2 instance provisioned with Node.js, npm, and PostgreSQL access

## Local CLI paths
- GitHub CLI local binary: `./dev-tools/gh/bin/gh.exe`
- AWS CLI local binary: `%APPDATA%\Python\Python313\Scripts\aws.cmd`

## GitHub repo setup
1. Authenticate GitHub CLI:
   - `gh auth login`
2. Create repository if needed:
   - `gh repo create Umkadjabborov/shop --public --source=. --remote=origin --push`

## GitHub Actions setup
1. Add repository secrets:
   - `GH_TOKEN` for GitHub API access if needed
   - `EC2_HOST` for the target EC2 public hostname or IP
   - `EC2_USER` for the SSH user
   - `EC2_SSH_PRIVATE_KEY` for the SSH private key

## AWS CLI setup
1. Configure AWS credentials:
   - `%APPDATA%\Python\Python313\Scripts\aws configure`
2. Set AWS region and default output format.

## Deploying
### Using GitHub Actions
- Push to `main`. The workflow `.github/workflows/deploy.yml` will build and upload an artifact, then deploy to EC2.

### Using local script
- Windows PowerShell:
  - `.
un-deploy.ps1 -EC2Host "<host>" -EC2User "ubuntu" -SSHKeyPath "C:\path\to\key.pem"`
- Bash:
  - `./deploy.sh`

## Notes
- Ensure `DATABASE_URL` is set in `Frontend/.env` or on EC2 before starting the app.
- The app listens on port `4001` by default.
