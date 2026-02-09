#!/bin/sh
set -x  # Enable debug logging

echo "=== PHP-FPM Container Startup ==="
echo "Starting PHP-FPM..."

# Check if php-fpm8.2 exists
which php-fpm8.2 || echo "ERROR: php-fpm8.2 not found"

# Start PHP-FPM in foreground (not daemon mode)
exec php-fpm8.2 -F