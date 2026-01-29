"""QRC Service - WiFi QR Code Generator for Home Assistant"""
from __future__ import annotations

import logging
from homeassistant.config_entries import ConfigEntry
from homeassistant.core import HomeAssistant
from homeassistant.helpers import service

from .const import DOMAIN
from .qr_generator import QRCodeGenerator

_LOGGER = logging.getLogger(__name__)

PLATFORMS = []


async def async_setup_entry(hass: HomeAssistant, entry: ConfigEntry) -> bool:
    """Set up QRC Service from a config entry."""
    hass.data.setdefault(DOMAIN, {})
    
    # Create QR generator instance
    qr_gen = QRCodeGenerator(hass, entry)
    hass.data[DOMAIN][entry.entry_id] = qr_gen
    
    # Register services
    await async_setup_services(hass, qr_gen)
    
    _LOGGER.info("QRC Service initialized successfully")
    return True


async def async_unload_entry(hass: HomeAssistant, entry: ConfigEntry) -> bool:
    """Unload a config entry."""
    hass.data[DOMAIN].pop(entry.entry_id)
    return True


async def async_setup_services(hass: HomeAssistant, qr_gen: QRCodeGenerator) -> None:
    """Register QRC Service services."""
    
    async def handle_generate_wifi_qr(call):
        """Handle generate_wifi_qr service call."""
        ssid = call.data.get("ssid")
        password = call.data.get("password")
        security = call.data.get("security", "WPA")
        size = call.data.get("size", 128)
        filename = call.data.get("filename", "wifi_qr.png")
        
        _LOGGER.info(f"Generating WiFi QR for SSID: {ssid}")
        
        result = await hass.async_add_executor_job(
            qr_gen.generate_wifi_qr,
            ssid,
            password,
            security,
            size,
            filename
        )
        
        if result:
            _LOGGER.info(f"QR code generated successfully: {filename}")
            # Fire event for QRCSatellite
            hass.bus.async_fire(f"{DOMAIN}_qr_generated", {
                "ssid": ssid,
                "filename": filename,
                "url": f"/local/qrcodes/{filename}"
            })
        else:
            _LOGGER.error(f"Failed to generate QR code for {ssid}")
    
    # Register service
    hass.services.async_register(
        DOMAIN,
        "generate_wifi_qr",
        handle_generate_wifi_qr
    )
