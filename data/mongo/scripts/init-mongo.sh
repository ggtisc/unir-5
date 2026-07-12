#!/bin/bash
set -euo pipefail

apt-get update -y
apt-get install -y awscli xfsprogs jq

TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
AZ=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
PRIVATE_IP=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

NODE_TAG=$(aws ec2 describe-tags --region "$REGION" --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=MongoNode" --query 'Tags[0].Value' --output text)
VOLUME_ID=$(aws ec2 describe-volumes --region "$REGION" --filters "Name=status,Values=available" "Name=availability-zone,Values=$AZ" "Name=tag:MongoNode,Values=$NODE_TAG" --query 'Volumes[0].VolumeId' --output text)

if [ -n "$VOLUME_ID" ] && [ "$VOLUME_ID" != "None" ]; then
  aws ec2 attach-volume --region "$REGION" --volume-id "$VOLUME_ID" --instance-id "$INSTANCE_ID" --device /dev/sdf

  DEVICE_NAME="/dev/sdf"
  NITRO_DEVICE="/dev/nvme1n1"

  while [ ! -e "$DEVICE_NAME" ] && [ ! -e "$NITRO_DEVICE" ]; do
    sleep 5
  done

  if [ -e "$NITRO_DEVICE" ]; then
    FINAL_DEVICE="$NITRO_DEVICE"
  else
    FINAL_DEVICE="$DEVICE_NAME"
  fi

  if ! blkid "$FINAL_DEVICE" >/dev/null 2>&1; then
    mkfs -t xfs "$FINAL_DEVICE"
  fi

  mkdir -p /var/lib/mongodb
  mount "$FINAL_DEVICE" /var/lib/mongodb
  
  UUID=$(blkid -s UUID -o value "$FINAL_DEVICE")
  echo "UUID=$UUID /var/lib/mongodb xfs defaults,nofail 0 2" >> /etc/fstab

  chown -R mongodb:mongodb /var/lib/mongodb
  sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf
  systemctl restart mongod
fi

aws servicediscovery register-instance \
    --service-id "${SERVICE_ID}" \
    --instance-id "$INSTANCE_ID" \
    --attributes AWS_INSTANCE_IPV4="$PRIVATE_IP" \
    --region "$REGION"