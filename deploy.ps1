param(
  [Parameter(Mandatory=$true)]
  [string]$EC2Host,

  [Parameter(Mandatory=$true)]
  [string]$EC2User,

  [Parameter(Mandatory=$true)]
  [string]$SSHKeyPath
)

Set-StrictMode -Version Latest
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $scriptDir

Write-Host 'Installing dependencies and building frontend...'
Set-Location .\Frontend
npm install
npm run build
Set-Location $scriptDir

$target = "$EC2User@$EC2Host:/home/$EC2User/shop"
Write-Host "Copying files to $target"
scp -i $SSHKeyPath -r .\Frontend\server .\Frontend\dist .\Frontend\package.json .\Frontend\package-lock.json $target

Write-Host 'Restarting application on EC2...'
ssh -i $SSHKeyPath $EC2User@$EC2Host "cd /home/$EC2User/shop && npm install --production && pm2 restart shop || pm2 start --name shop npm -- start"
