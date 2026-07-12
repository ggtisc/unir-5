#!/bin/bash
set -euo pipefail

echo "--- Setting environment variables ---"

mkdir -p /opt/mean-app

cat > /opt/mean-app/.env <<ENV
MONGO_URI=${MONGO_URI}
ENV

chmod 600 /opt/mean-app/.env

echo "--- Rebooting Docker Compose ---"
systemctl restart mean-app.service

echo "--- Reboot complete ---"