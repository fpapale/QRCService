# QRC Service

Generate WiFi QR codes for ESPHome devices directly from Home Assistant!

## Quick Features

- 🎯 **One-click QR generation** via HA service
- 📱 **Compatible with QRCSatellite** (ATOM S3 display)
- 🔧 **Easy UI configuration** 
- 📂 **Auto-saves** to `/config/www/qrcodes/`
- 🔄 **Event-driven** updates

## Installation

### HACS (Recommended)

1. Open HACS → Integrations
2. Click ⋮ → Custom repositories
3. Add: `https://github.com/fpapale/QRCService`
4. Category: Integration
5. Click "Download"
6. Restart Home Assistant
7. Add integration: Settings → Devices & Services → + ADD INTEGRATION → "QRC Service"

### Manual

1. Copy `custom_components/qrcservice` to `/config/custom_components/`
2. Restart HA
3. Add integration via UI

## Quick Start

```yaml
# Generate a WiFi QR code
service: qrcservice.generate_wifi_qr
data:
  ssid: "MyWiFi"
  password: "MyPassword"
  size: 128
  filename: "guest_wifi.png"
```

QR code saved to: `/config/www/qrcodes/guest_wifi.png`

Accessible at: `http://homeassistant.local:8123/local/qrcodes/guest_wifi.png`

## Documentation

See [full README](README.md) for complete documentation.

## Support

- **Issues**: [GitHub Issues](https://github.com/fpapale/QRCService/issues)
- **Discussions**: [GitHub Discussions](https://github.com/fpapale/QRCService/discussions)

## Companion Project

**QRCSatellite** - ESPHome client for displaying QR codes on ATOM S3 devices
