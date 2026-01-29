"""QR Code Generator for WiFi credentials."""
from __future__ import annotations

import logging
import os
from pathlib import Path

import qrcode
from PIL import Image

from homeassistant.core import HomeAssistant
from homeassistant.config_entries import ConfigEntry

from .const import (
    CONF_OUTPUT_DIR,
    CONF_DEFAULT_SIZE,
    CONF_ERROR_CORRECTION,
    DEFAULT_OUTPUT_DIR,
    DEFAULT_SIZE,
    DEFAULT_ERROR_CORRECTION,
    ERROR_CORRECTION_LEVELS,
)

_LOGGER = logging.getLogger(__name__)


class QRCodeGenerator:
    """Generate WiFi QR codes."""

    def __init__(self, hass: HomeAssistant, entry: ConfigEntry) -> None:
        """Initialize the QR code generator."""
        self.hass = hass
        self._output_dir = entry.data.get(CONF_OUTPUT_DIR, DEFAULT_OUTPUT_DIR)
        self._default_size = entry.data.get(CONF_DEFAULT_SIZE, DEFAULT_SIZE)
        self._error_correction_level = entry.data.get(
            CONF_ERROR_CORRECTION, DEFAULT_ERROR_CORRECTION
        )
        
        # Ensure output directory exists
        self._ensure_output_dir()

    def _ensure_output_dir(self) -> None:
        """Ensure the output directory exists."""
        full_path = Path(self.hass.config.path(self._output_dir))
        full_path.mkdir(parents=True, exist_ok=True)
        _LOGGER.info(f"QR codes will be saved to: {full_path}")

    def generate_wifi_qr(
        self,
        ssid: str,
        password: str,
        security: str = "WPA",
        size: int | None = None,
        filename: str = "wifi_qr.png",
    ) -> bool:
        """Generate a WiFi QR code.
        
        Args:
            ssid: WiFi network SSID
            password: WiFi password
            security: Security type (WPA/WEP/nopass)
            size: QR code size in pixels
            filename: Output filename
            
        Returns:
            True if successful, False otherwise
        """
        try:
            # Build WiFi QR string
            wifi_string = self._build_wifi_string(ssid, password, security)
            
            # Use default size if not provided
            if size is None:
                size = self._default_size
            
            # Get error correction constant
            error_correction = getattr(
                qrcode.constants,
                f"ERROR_CORRECT_{self._error_correction_level}"
            )
            
            # Generate QR code
            qr = qrcode.QRCode(
                version=None,  # Auto-fit
                error_correction=error_correction,
                box_size=max(1, size // 25),  # Scale box size based on target size
                border=2,
            )
            qr.add_data(wifi_string)
            qr.make(fit=True)
            
            # Create image
            img = qr.make_image(fill_color="black", back_color="white")
            
            # Resize to exact size
            img_resized = img.resize((size, size), Image.LANCZOS)
            
            # Save to output directory
            output_path = Path(self.hass.config.path(self._output_dir)) / filename
            img_resized.save(output_path)
            
            _LOGGER.info(f"QR code saved to: {output_path}")
            return True
            
        except Exception as e:
            _LOGGER.error(f"Failed to generate QR code: {e}")
            return False

    def _build_wifi_string(self, ssid: str, password: str, security: str) -> str:
        """Build WiFi QR code string.
        
        Format: WIFI:T:WPA;S:ssid;P:password;;
        """
        # Escape special characters
        ssid_escaped = self._escape_string(ssid)
        password_escaped = self._escape_string(password)
        
        return f"WIFI:T:{security};S:{ssid_escaped};P:{password_escaped};;"

    @staticmethod
    def _escape_string(text: str) -> str:
        """Escape special characters in WiFi QR string."""
        # Escape backslash, semicolon, colon, and comma
        special_chars = ['\\', ';', ':', ',', '"']
        for char in special_chars:
            text = text.replace(char, f'\\{char}')
        return text
