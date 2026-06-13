#!/usr/bin/env pwsh
param(
  [switch]$NoPS = $false
)

# Get script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Setup PATH with local tools
$env:Path = @(
  "$scriptDir\dev-tools\gh\bin",
  "$env:APPDATA\Python\Python313\Scripts",
  $env:Path
) -join [System.IO.Path]::PathSeparator

Write-Host @"
========================================
 OpenShop - Development Environment
========================================

Local CLI tools configured:
  - gh (GitHub CLI) from: ./dev-tools/gh/bin
  - aws (AWS CLI) from: $env:APPDATA\Python\Python313\Scripts

PATH updated. Type 'gh --version' and 'aws --version' to verify.
========================================
"@ -ForegroundColor Green

if (-not $NoPS) {
  Write-Host "`nStarting new PowerShell session..." -ForegroundColor Cyan
  & pwsh -NoExit
}
