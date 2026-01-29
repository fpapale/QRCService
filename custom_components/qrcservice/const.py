"""Constants for QRC Service integration."""

DOMAIN = "qrcservice"

# Configuration
CONF_OUTPUT_DIR = "output_dir"
CONF_DEFAULT_SIZE = "default_size"
CONF_ERROR_CORRECTION = "error_correction"

# Defaults
DEFAULT_OUTPUT_DIR = "www/qrcodes"
DEFAULT_SIZE = 128
DEFAULT_ERROR_CORRECTION = "M"

# Error correction levels
ERROR_CORRECTION_LEVELS = {
    "L": 1,  # ~7% errors
    "M": 0,  # ~15% errors (default)
    "Q": 3,  # ~25% errors
    "H": 2,  # ~30% errors
}

# Security types
SECURITY_TYPES = ["WPA", "WEP", "nopass"]
