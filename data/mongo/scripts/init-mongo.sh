#!/bin/bash
set -euo pipefail

# 1. Instalar dependencias requeridas (AWS CLI y utilidades de disco)
apt-get update -y
apt-get install -y awscli xfsprogs

# 2. Obtener Metadata
TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document | grep -o '"region"[[:space:]]*:[[:space:]]*"[^"]*"' | awk -F'"' '{print $4}')
AZ=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

# 3. Descubrir quién soy y qué disco me toca
NODE_TAG=$(aws ec2 describe-tags --region "$REGION" --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=MongoNode" --query 'Tags[0].Value' --output text)
VOLUME_ID=$(aws ec2 describe-volumes --region "$REGION" --filters "Name=status,Values=available" "Name=availability-zone,Values=$AZ" "Name=tag:MongoNode,Values=$NODE_TAG" --query 'Volumes[0].VolumeId' --output text)

# 4. Conectar y Montar
if [ -n "$VOLUME_ID" ] && [ "$VOLUME_ID" != "None" ]; then
  aws ec2 attach-volume --region "$REGION" --volume-id "$VOLUME_ID" --instance-id "$INSTANCE_ID" --device /dev/sdf

  # Compatibilidad Xen (t2) y Nitro (t3)
  DEVICE_NAME="/dev/sdf"
  NITRO_DEVICE="/dev/nvme1n1"

  # Esperar a que el disco físico aparezca en cualquiera de las dos rutas
  while [ ! -e "$DEVICE_NAME" ] && [ ! -e "$NITRO_DEVICE" ]; do
    sleep 5
  done

  # Determinar cuál es el nombre final que le dio el SO
  if [ -e "$NITRO_DEVICE" ]; then
    FINAL_DEVICE="$NITRO_DEVICE"
  else
    FINAL_DEVICE="$DEVICE_NAME"
  fi

  # Formatear si está crudo
  if ! blkid "$FINAL_DEVICE" >/dev/null 2>&1; then
    mkfs -t xfs "$FINAL_DEVICE"
  fi

  # Montaje persistente
  mkdir -p /var/lib/mongodb
  mount "$FINAL_DEVICE" /var/lib/mongodb
  
  # Obtener el UUID para un fstab más seguro y escribirlo
  UUID=$(blkid -s UUID -o value "$FINAL_DEVICE")
  echo "UUID=$UUID /var/lib/mongodb xfs defaults,nofail 0 2" >> /etc/fstab
fi