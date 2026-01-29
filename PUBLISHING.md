# Publishing QRCService to GitHub for HACS

Follow these steps to publish QRCService to `https://github.com/fpapale/QRCService`:

## Prerequisites

- Git installed
- GitHub account (fpapale)
- GitHub CLI (optional, recommended): `gh` command

## Steps

### 1. Initialize Git Repository

```bash
cd d:/antigravity/execution/QRCService

# Initialize git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial release v1.0.0 - WiFi QR Code Generator for HA"
```

### 2. Create GitHub Repository

**Option A: Via GitHub CLI (recommended)**
```bash
gh repo create fpapale/QRCService --public --source=. --remote=origin --push
gh repo edit fpapale/QRCService --description "WiFi QR Code Generator for Home Assistant - HACS Integration"
gh repo edit fpapale/QRCService --add-topic home-assistant,hacs,qr-code,wifi,esphome
```

**Option B: Via GitHub Web**
1. Go to https://github.com/new
2. Repository name: `QRCService`
3. Description: `WiFi QR Code Generator for Home Assistant - HACS Integration`
4. Public repository
5. **DO NOT** initialize with README, .gitignore, or license (we already have them)
6. Click "Create repository"

Then link local to remote:
```bash
git remote add origin https://github.com/fpapale/QRCService.git
git branch -M main
git push -u origin main
```

### 3. Create Release Tag

```bash
# Tag version 1.0.0
git tag -a v1.0.0 -m "Release v1.0.0 - Initial HACS-compatible release"
git push origin v1.0.0
```

**Or via GitHub CLI:**
```bash
gh release create v1.0.0 --title "v1.0.0 - Initial Release" --notes "
## Features
- Generate WiFi QR codes via Home Assistant service
- Configurable via UI
- Compatible with QRCSatellite (ESPHome client)
- Customizable QR size and error correction
- Event-driven updates

## Installation
Install via HACS or manually copy to custom_components/

## Breaking Changes
None (initial release)
"
```

### 4. Add to HACS (User Installation)

Now users can add your integration:

1. Open HACS in Home Assistant
2. Click ⋮ (three dots) → **Custom repositories**
3. Add repository:
   - **URL**: `https://github.com/fpapale/QRCService`
   - **Category**: Integration
4. Click **Add**
5. Find "QRC Service" in integrations list
6. Click **Download**
7. Restart Home Assistant
8. Add integration: Settings → Devices & Services → + ADD INTEGRATION

### 5. Optional: Add to HACS Default Repositories

To make QRCService appear in HACS by default (without custom repo):

1. Fork https://github.com/hacs/default
2. Edit `integration` file
3. Add entry:
   ```json
   {
     "name": "fpapale/QRCService",
     "description": "WiFi QR Code Generator for Home Assistant"
   }
   ```
4. Create Pull Request to HACS/default

**Requirements for HACS default:**
- Repository must be public
- Must have proper `hacs.json`
- Must follow HACS quality requirements
- Must have documentation

### 6. Repository Settings (GitHub Web)

**Add Topics:**
- `home-assistant`
- `hacs`
- `qr-code`
- `wifi`
- `esphome`
- `integration`
- `custom-component`

**Add Description:**
```
WiFi QR Code Generator for Home Assistant - HACS Integration compatible with QRCSatellite
```

**Enable Issues and Discussions:**
- Settings → General → Features → Check "Issues" and "Discussions"

### 7. Verify HACS Compatibility

Check your repository structure:
```
QRCService/
├── custom_components/
│   └── qrcservice/
│       ├── __init__.py
│       ├── manifest.json      ✓ Required
│       ├── config_flow.py
│       └── ...
├── hacs.json                  ✓ Required
├── README.md                  ✓ Required
├── LICENSE                    ✓ Required
├── info.md                    ✓ Required
└── .gitignore
```

Test with HACS Validator:
```bash
# Optional: Validate before publishing
pip install hacs-validation
hacs-validation --repository fpapale/QRCService
```

### 8. Update Future Versions

When updating:
```bash
# Make changes
git add .
git commit -m "Fix: Description of changes"
git push

# Update version in manifest.json (e.g., 1.0.1)
# Then create new release
git tag -a v1.0.1 -m "Release v1.0.1 - Bug fixes"
git push origin v1.0.1

# Create GitHub release
gh release create v1.0.1 --title "v1.0.1 - Bug Fixes" --notes "
## Changes
- Fixed XYZ

## Breaking Changes
None
"
```

## Testing Installation

After publishing, test the installation:

1. In another HA instance, add as custom repository
2. Install via HACS
3. Restart HA
4. Configure integration
5. Test service call
6. Verify QR code generation

## Repository Maintenance

**README badges** (add to README.md):
```markdown
[![hacs_badge](https://img.shields.io/badge/HACS-Custom-orange.svg)](https://github.com/fpapale/QRCService)
[![GitHub release](https://img.shields.io/github/release/fpapale/QRCService.svg)](https://github.com/fpapale/QRCService/releases)
[![GitHub issues](https://img.shields.io/github/issues/fpapale/QRCService)](https://github.com/fpapale/QRCService/issues)
[![License](https://img.shields.io/github/license/fpapale/QRCService.svg)](LICENSE)
```

## Troubleshooting

### HACS not finding repository
- Ensure repository is public
- Check `hacs.json` is valid
- Verify `manifest.json` has correct domain
- Wait a few minutes after repository creation

### Installation fails
- Check Home Assistant logs
- Verify Python requirements are correct
- Test locally first before publishing

## Resources

- HACS Documentation: https://hacs.xyz/docs/publish/integration
- HA Integration Documentation: https://developers.home-assistant.io/docs/creating_integration_manifest
- Example integrations: https://github.com/hacs/default/blob/master/integration

## Quick Command Cheat Sheet

```bash
# Complete setup in one go
cd d:/antigravity/execution/QRCService
git init
git add .
git commit -m "Initial release v1.0.0"
gh repo create fpapale/QRCService --public --source=. --remote=origin --push
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
gh release create v1.0.0 --title "v1.0.0 - Initial Release" --generate-notes
```

Done! Your integration is now available at:
- Repository: https://github.com/fpapale/QRCService
- Installation URL for HACS: `https://github.com/fpapale/QRCService`
