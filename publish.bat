@echo off
REM Quick publish script for QRCService to GitHub (Windows)
setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Publishing QRCService to GitHub
echo ========================================
echo.

REM Check if we're in the right directory
if not exist "hacs.json" (
    echo [ERROR] Not in QRCService directory
    echo Please run this script from the QRCService folder
    pause
    exit /b 1
)

REM Check if git is initialized
if not exist ".git" (
    echo [STEP 1] Initializing git repository...
    git init
    if errorlevel 1 (
        echo [ERROR] Failed to initialize git
        pause
        exit /b 1
    )
)

REM Add all files
echo [STEP 2] Adding files to git...
git add .
if errorlevel 1 (
    echo [ERROR] Failed to add files
    pause
    exit /b 1
)

REM Commit
set /p commit_msg="Enter commit message (or press Enter for default): "
if "!commit_msg!"=="" set commit_msg=Initial release v1.0.0 - WiFi QR Code Generator for HA

echo [STEP 3] Committing with message: !commit_msg!
git commit -m "!commit_msg!"
if errorlevel 1 (
    echo [ERROR] Failed to commit
    pause
    exit /b 1
)

REM Check if gh CLI is available
where gh >nul 2>nul
if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] GitHub CLI detected
    echo.
    
    REM Check authentication
    echo [STEP 4] Checking GitHub authentication...
    gh auth status >nul 2>nul
    if errorlevel 1 (
        echo [WARNING] Not authenticated with GitHub
        echo Please authenticate first:
        echo   gh auth login
        echo.
        pause
        exit /b 1
    )
    
    REM Create repository
    echo [STEP 5] Creating GitHub repository fpapale/QRCService...
    gh repo create fpapale/QRCService --public --source=. --remote=origin --push
    if errorlevel 1 (
        echo [INFO] Repository might already exist, continuing...
    )
    
    REM Add description and topics
    echo [STEP 6] Setting repository metadata...
    gh repo edit fpapale/QRCService --description "WiFi QR Code Generator for Home Assistant - HACS Integration"
    gh repo edit fpapale/QRCService --add-topic home-assistant
    gh repo edit fpapale/QRCService --add-topic hacs
    gh repo edit fpapale/QRCService --add-topic qr-code
    gh repo edit fpapale/QRCService --add-topic wifi
    gh repo edit fpapale/QRCService --add-topic esphome
    gh repo edit fpapale/QRCService --add-topic integration
    gh repo edit fpapale/QRCService --add-topic custom-component
    
    REM Create tag
    echo [STEP 7] Creating tag v1.0.0...
    git tag -a v1.0.0 -m "Release v1.0.0"
    git push origin v1.0.0
    
    REM Create release
    echo [STEP 8] Creating GitHub release v1.0.0...
    gh release create v1.0.0 --title "v1.0.0 - Initial Release" --notes "## Features%0A- Generate WiFi QR codes via Home Assistant service%0A- Configurable via UI%0A- Compatible with QRCSatellite (ESPHome client)%0A- Customizable QR size and error correction%0A- Event-driven updates%0A%0A## Installation%0AInstall via HACS by adding custom repository:%0Ahttps://github.com/fpapale/QRCService%0A%0ACategory: Integration"
    
    echo.
    echo ========================================
    echo   Published successfully!
    echo ========================================
    echo.
    echo Repository: https://github.com/fpapale/QRCService
    echo.
    echo Next steps for users:
    echo 1. HACS -^> Integrations -^> Custom repositories
    echo 2. Add: https://github.com/fpapale/QRCService
    echo 3. Category: Integration
    echo 4. Download -^> Restart HA
    echo.
    
) else (
    echo.
    echo [WARNING] GitHub CLI not found
    echo.
    echo Installing via winget...
    winget install --id GitHub.cli
    
    if errorlevel 1 (
        echo.
        echo [INFO] Could not auto-install GitHub CLI
        echo.
        echo Please install manually:
        echo 1. Download from: https://cli.github.com/
        echo 2. Or run: winget install --id GitHub.cli
        echo 3. Restart this script after installation
        echo.
        pause
        exit /b 1
    )
    
    echo.
    echo [SUCCESS] GitHub CLI installed
    echo Please restart this script and authenticate with:
    echo   gh auth login
    echo.
)

echo.
pause
