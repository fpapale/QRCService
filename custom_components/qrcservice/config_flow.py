"""Config flow for QRC Service integration."""
from __future__ import annotations

import logging
from typing import Any

import voluptuous as vol

from homeassistant import config_entries
from homeassistant.core import HomeAssistant
from homeassistant.data_entry_flow import FlowResult

from .const import (
    DOMAIN,
    CONF_OUTPUT_DIR,
    CONF_DEFAULT_SIZE,
    CONF_ERROR_CORRECTION,
    DEFAULT_OUTPUT_DIR,
    DEFAULT_SIZE,
    DEFAULT_ERROR_CORRECTION,
    ERROR_CORRECTION_LEVELS,
)

_LOGGER = logging.getLogger(__name__)


class QRCServiceConfigFlow(config_entries.ConfigFlow, domain=DOMAIN):
    """Handle a config flow for QRC Service."""

    VERSION = 1

    async def async_step_user(
        self, user_input: dict[str, Any] | None = None
    ) -> FlowResult:
        """Handle the initial step."""
        errors = {}

        if user_input is not None:
            # Validate output directory
            output_dir = user_input.get(CONF_OUTPUT_DIR, DEFAULT_OUTPUT_DIR)
            
            # Create unique ID based on output dir
            await self.async_set_unique_id(f"qrcservice_{output_dir}")
            self._abort_if_unique_id_configured()

            return self.async_create_entry(
                title="QRC Service",
                data=user_input,
            )

        # Schema for configuration
        data_schema = vol.Schema(
            {
                vol.Optional(
                    CONF_OUTPUT_DIR,
                    default=DEFAULT_OUTPUT_DIR
                ): str,
                vol.Optional(
                    CONF_DEFAULT_SIZE,
                    default=DEFAULT_SIZE
                ): vol.All(vol.Coerce(int), vol.Range(min=64, max=512)),
                vol.Optional(
                    CONF_ERROR_CORRECTION,
                    default=DEFAULT_ERROR_CORRECTION
                ): vol.In(ERROR_CORRECTION_LEVELS.keys()),
            }
        )

        return self.async_show_form(
            step_id="user",
            data_schema=data_schema,
            errors=errors,
        )
