# Quick publish script for QRCService to GitHub (PowerShell)
# Usage: .\publish.ps1

$ErrorActionPreference = "Stop"

Write-Host "`n========================================"
Write-Host "  Publishing QRCService to GitHub"
Write-Host "========================================`n" -ForegroundColor Cyan

# Check if we're in the right directory
if (-not (Test-Path "hacs.json")) {
    Write-Host "[ERROR] Not in QRCService directory" -ForegroundColor Red
    Write-Host "Please run this script from the QRCService folder"
    pause
    exit 1
}

# Check if git is initialized
if (-not (Test-Path ".git")) {
    Write-Host "[STEP 1] Initializing git repository..." -ForegroundColor Yellow
    git init
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to initialize git" -ForegroundColor Red
        pause
        exit 1
    }
}

# Add all files
Write-Host "[STEP 2] Adding files to git..." -ForegroundColor Yellow
git add .
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to add files" -ForegroundColor Red
    pause
    exit 1
}

# Commit
$commitMsg = Read-Host "Enter commit message (or press Enter for default)"
if ([string]::IsNullOrWhiteSpace($commitMsg)) {
    $commitMsg = "Initial release v1.0.0 - WiFi QR Code Generator for HA"
}

Write-Host "[STEP 3] Committing with message: $commitMsg" -ForegroundColor Yellow
git commit -m $commitMsg
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to commit" -ForegroundColor Red
    pause
    exit 1
}

# Check if gh CLI is available
$ghInstalled = Get-Command gh -ErrorAction SilentlyContinue

if ($ghInstalled) {
    Write-Host "`n[SUCCESS] GitHub CLI detected" -ForegroundColor Green
    
    # Check authentication
    Write-Host "[STEP 4] Checking GitHub authentication..." -ForegroundColor Yellow
    $authStatus = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[WARNING] Not authenticated with GitHub" -ForegroundColor Yellow
        Write-Host "Please authenticate first:"
        Write-Host "  gh auth login" -ForegroundColor Cyan
        pause
        exit 1
    }
    
    # Create repository
    Write-Host "[STEP 5] Creating GitHub repository fpapale/QRCService..." -ForegroundColor Yellow
    gh repo create fpapale/QRCService --public --source=. --remote=origin --push 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[INFO] Repository might already exist, continuing..." -ForegroundColor Cyan
    }
    
    # Add description and topics
    Write-Host "[STEP 6] Setting repository metadata..." -ForegroundColor Yellow
    gh repo edit fpapale/QRCService --description "WiFi QR Code Generator for Home Assistant - HACS Integration"
    gh repo edit fpapale/QRCService --add-topic home-assistant
    gh repo edit fpapale/QRCService --add-topic hacs
    gh repo edit fpapale/QRCService --add-topic qr-code
    gh repo edit fpapale/QRCService --add-topic wifi
    gh repo edit fpapale/QRCService --add-topic esphome
    gh repo edit fpapale/QRCService --add-topic integration
    gh repo edit fpapale/QRCService --add-topic custom-component
    
    # Create tag
    Write-Host "[STEP 7] Creating tag v1.0.0..." -ForegroundColor Yellow
    git tag -a v1.0.0 -m "Release v1.0.0"
    git push origin v1.0.0
    
    # Create release
    Write-Host "[STEP 8] Creating GitHub release v1.0.0..." -ForegroundColor Yellow
    $releaseNotes = @"
## Features
- Generate WiFi QR codes via Home Assistant service
- Configurable via UI
- Compatible with QRCSatellite (ESPHome client)
- Customizable QR size and error correction
- Event-driven updates

## Installation
Install via HACS by adding custom repository:
https://github.com/fpapale/QRCService

Category: Integration
"@
    
    gh release create v1.0.0 --title "v1.0.0 - Initial Release" --notes $releaseNotes
    
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "  Published successfully!" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Green
    
    Write-Host "Repository: " -NoNewline
    Write-Host "https://github.com/fpapale/QRCService" -ForegroundColor Cyan
    Write-Host "`nNext steps for users:"
    Write-Host "1. HACS -> Integrations -> Custom repositories"
    Write-Host "2. Add: https://github.com/fpapale/QRCService"
    Write-Host "3. Category: Integration"
    Write-Host "4. Download -> Restart HA`n"
    
} else {
    Write-Host "`n[WARNING] GitHub CLI not found" -ForegroundColor Yellow
    Write-Host "Installing via winget...`n" -ForegroundColor Yellow
    
    try {
        winget install --id GitHub.cli
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`n[SUCCESS] GitHub CLI installed" -ForegroundColor Green
            Write-Host "Please restart PowerShell and authenticate with:" -ForegroundColor Cyan
            Write-Host "  gh auth login" -ForegroundColor Cyan
            Write-Host "Then run this script again.`n"
        }
    } catch {
        Write-Host "`n[INFO] Could not auto-install GitHub CLI" -ForegroundColor Yellow
        Write-Host "`nPlease install manually:"
        Write-Host "1. Download from: https://cli.github.com/"
        Write-Host "2. Or run: winget install --id GitHub.cli"
        Write-Host "3. Restart PowerShell and run this script again`n"
    }
}

pause
