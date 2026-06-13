@echo off
REM Add local dev tools to PATH and start PowerShell
setlocal enabledelayedexpansion

set LOCAL_GH=%~dp0dev-tools\gh\bin
set LOCAL_AWS=%APPDATA%\Python\Python313\Scripts
set ORIGINAL_PATH=%PATH%

setlocal
set PATH=%LOCAL_GH%;%LOCAL_AWS%;%ORIGINAL_PATH%

@echo.
@echo ========================================
@echo  OpenShop - Development Environment
@echo ========================================
@echo.
@echo Local CLI tools available:
@echo   - gh (GitHub CLI): %LOCAL_GH%\gh.exe
@echo   - aws (AWS CLI): %LOCAL_AWS%\aws.cmd
@echo.
@echo PATH updated to include local tools.
@echo Type 'gh --version' and 'aws --version' to verify.
@echo.

powershell -NoExit -Command "Write-Host 'PowerShell environment ready with gh and aws commands' -ForegroundColor Green"
