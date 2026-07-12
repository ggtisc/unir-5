#!/bin/bash
set -euo pipefail

echo "--- Getting AWS PS secrets ---"
DB_USER=$(aws ssm get-parameter --name "/iaas/mongo/db/user" --with-decryption --query "Parameter.Value" --output text)
DB_PASSWORD=$(aws ssm get-parameter --name "/iaas/mongo/db/pass" --with-decryption --query "Parameter.Value" --output text)
DB_AUTH_SOURCE=$(aws ssm get-parameter --name "/iaas/mongo/db/auth" --with-decryption --query "Parameter.Value" --output text)

echo "--- Setting environment variables ---"

mkdir -p /opt/mean-app

cat > /opt/mean-app/.env <<ENV
MONGO_URI=${MONGO_URI}
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_AUTH_SOURCE=$DB_AUTH_SOURCE
ENV

chmod 600 /opt/mean-app/.env

echo "--- Rebooting Docker Compose ---"
systemctl restart mean-app.service

echo "--- Reboot complete ---"