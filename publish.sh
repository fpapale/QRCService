#!/bin/bash
# Quick publish script for QRCService to GitHub

set -e  # Exit on error

echo "🚀 Publishing QRCService to GitHub..."

# Check if we're in the right directory
if [ ! -f "hacs.json" ]; then
    echo "❌ Error: Not in QRCService directory"
    exit 1
fi

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📦 Initializing git repository..."
    git init
fi

# Add all files
echo "📝 Adding files to git..."
git add .

# Commit
read -p "Enter commit message (default: 'Initial release v1.0.0'): " commit_msg
commit_msg=${commit_msg:-"Initial release v1.0.0 - WiFi QR Code Generator for HA"}
git commit -m "$commit_msg"

# Check if gh CLI is available
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI detected"
    
    # Create repository
    echo "🔨 Creating GitHub repository fpapale/QRCService..."
    gh repo create fpapale/QRCService --public --source=. --remote=origin --push || echo "Repository might already exist"
    
    # Add description and topics
    echo "📋 Setting repository metadata..."
    gh repo edit fpapale/QRCService \
        --description "WiFi QR Code Generator for Home Assistant - HACS Integration" \
        --add-topic home-assistant \
        --add-topic hacs \
        --add-topic qr-code \
        --add-topic wifi \
        --add-topic esphome \
        --add-topic integration \
        --add-topic custom-component
    
    # Create release
    echo "🏷️  Creating release v1.0.0..."
    gh release create v1.0.0 \
        --title "v1.0.0 - Initial Release" \
        --notes "## Features
- Generate WiFi QR codes via Home Assistant service
- Configurable via UI
- Compatible with QRCSatellite (ESPHome client)
- Customizable QR size and error correction
- Event-driven updates

## Installation
Install via HACS by adding custom repository:
\`https://github.com/fpapale/QRCService\`

Category: Integration"
    
    echo "✅ Published successfully!"
    echo "📍 Repository: https://github.com/fpapale/QRCService"
    echo ""
    echo "🎉 Next steps:"
    echo "1. Users can add to HACS: https://github.com/fpapale/QRCService"
    echo "2. Category: Integration"
    echo "3. After download, restart HA and add integration"
    
else
    echo "⚠️  GitHub CLI not found. Using manual method..."
    
    # Check if remote exists
    if ! git remote | grep -q origin; then
        echo "🔗 Adding remote origin..."
        git remote add origin https://github.com/fpapale/QRCService.git
    fi
    
    # Push to main
    echo "📤 Pushing to GitHub..."
    git branch -M main
    git push -u origin main
    
    # Create tag
    echo "🏷️  Creating tag v1.0.0..."
    git tag -a v1.0.0 -m "Release v1.0.0"
    git push origin v1.0.0
    
    echo "✅ Code pushed to GitHub!"
    echo ""
    echo "⚠️  Manual steps required:"
    echo "1. Go to https://github.com/fpapale/QRCService/releases/new"
    echo "2. Select tag: v1.0.0"
    echo "3. Title: v1.0.0 - Initial Release"
    echo "4. Add release notes and publish"
    echo ""
    echo "5. Add topics in repository settings:"
    echo "   home-assistant, hacs, qr-code, wifi, esphome, integration"
fi
