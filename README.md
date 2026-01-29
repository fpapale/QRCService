# QRC Service

<function_calls>
<invoke name="write_to_file">
<parameter name="CodeContent"># QRC Service

**WiFi QR Code Generator for Home Assistant**

Generate WiFi QR codes that can be displayed on ESPHome devices like the ATOM S3.

## Features

- 🎯 Generate WiFi QR codes via Home Assistant service
- 🔧 Configurable via UI (Settings → Devices & Services)
- 📱 Compatible with QRCSatellite (ESPHome client)
- 🎨 Customizable QR size and error correction
- 📂 Auto-saves to `/config/www/qrcodes/`
- 🔄 Event-driven updates for connected devices

## Installation

### Via HACS (Recommended)

1. Open HACS in Home Assistant
2. Click on "Integrations"
3. Click the "+" button
4. Search for "QRC Service"
5. Click "Download"
6. Restart Home Assistant

### Manual Installation

1. Copy `custom_components/qrcservice` to your `/config/custom_components/` directory
2. Restart Home Assistant
3. Go to Settings → Devices & Services → Add Integration
4. Search for "QRC Service"

## Configuration

**UI Setup:**
1. Go to Settings → Devices & Services
2. Click "+ ADD INTEGRATION"
3. Search for "QRC Service"
4. Configure:
   - **Output Directory**: Where to save QR codes (default: `www/qrcodes`)
   - **Default QR Size**: Size in pixels (default: 128)
   - **Error Correction**: L/M/Q/H (default: M)

## Usage

### Service: `qrcservice.generate_wifi_qr`

Generate a WiFi QR code image.

**Example:**
```yaml
service: qrcservice.generate_wifi_qr
data:
  ssid: "MyWiFiNetwork"
  password: "MySecurePassword"
  security: "WPA"
  size: 128
  filename: "guest_wifi.png"
```

**Parameters:**
- `ssid` (required): WiFi network name
- `password` (required): WiFi password
- `security` (optional): WPA/WEP/nopass (default: WPA)
- `size` (optional): QR code size in pixels (default: 128)
- `filename` (optional): Output filename (default: wifi_qr.png)

**Output:**
- File saved to: `/config/www/qrcodes/{filename}`
- Accessible at: `http://homeassistant.local:8123/local/qrcodes/{filename}`

### Events

When a QR code is generated, the service fires an event:

```yaml
event_type: qrcservice_qr_generated
event_data:
  ssid: "MyWiFiNetwork"
  filename: "wifi_qr.png"
  url: "/local/qrcodes/wifi_qr.png"
```

**Listen for events:**
```yaml
automation:
  - alias: "QR Generated Notification"
    trigger:
      - platform: event
        event_type: qrcservice_qr_generated
    action:
      - service: notify.mobile_app
        data:
          message: "QR code ready for {{ trigger.event.data.ssid }}"
```

## Integration with QRCSatellite

QRCSatellite is an ESPHome client for ATOM S3 that displays generated QR codes.

**Example automation:**
```yaml
automation:
  - alias: "Generate QR for ATOM S3"
    trigger:
      - platform: state
        entity_id: text_sensor.atom_s3_current_network
    action:
      - service: qrcservice.generate_wifi_qr
        data:
          ssid: "{{ states('text_sensor.atom_s3_ssid') }}"
          password: "{{ states('text_sensor.atom_s3_password') }}"
          filename: "atom_s3_qr.png"
```

## QR Code Format

WiFi QR codes use the standard format:
```
WIFI:T:WPA;S:NetworkName;P:Password;;
```

Compatible with iOS, Android, and most QR scanners.

## Troubleshooting

### QR code not showing
- Check `/config/www/qrcodes/` directory exists
- Verify permissions: `chmod 755 /config/www/qrcodes`
- Check Home Assistant logs: Settings → System → Logs

### Service not available
- Verify integration is installed: Settings → Devices & Services
- Check `qrcode` library is installed (auto-installed via manifest)
- Restart Home Assistant

### Image quality issues
- Increase QR size (128, 256, or 512 pixels)
- Change error correction level (H for best resistance)

## Development

**Test service:**
```bash
# In HA Developer Tools → Services
service: qrcservice.generate_wifi_qr
data:
  ssid: "TestNetwork"
  password: "TestPass123"
```

**Check output:**
```bash
ls -la /config/www/qrcodes/
```

## License

MIT License - See LICENSE file

## Support

- Issues: https://github.com/yourusername/qrcservice/issues
- Discussions: https://github.com/yourusername/qrcservice/discussions
