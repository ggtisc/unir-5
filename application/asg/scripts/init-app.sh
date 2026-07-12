#!/bin/bash
set -euo pipefail

echo "--- Configurando variables de entorno de la Aplicación ---"

# Crear el directorio por si no existe
mkdir -p /opt/mean-app

# Inyectar las variables en el archivo .env
cat > /opt/mean-app/.env <<ENV
MONGO_URI=${MONGO_URI}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}
DB_AUTH_SOURCE=${DB_AUTH_SOURCE}
ENV

# Proteger el archivo con credenciales
chmod 600 /opt/mean-app/.env

echo "--- Reiniciando el servicio Docker Compose ---"
# Reiniciar el servicio nativo tal como lo hacías antes
systemctl restart mean-app.service

echo "--- Inicialización completada ---"