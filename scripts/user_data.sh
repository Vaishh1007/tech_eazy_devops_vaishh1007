#!/bin/bash
# EC2 bootstrap script for Assignment 3

# Update system
yum update -y

# Install dependencies
yum install -y docker git awscli

# Start Docker
systemctl start docker
systemctl enable docker

# App logs
mkdir -p /app/logs
echo "App started on $(date)" >> /app/logs/app.log

# Upload logs script
cat <<'EOT' > /usr/local/bin/upload-logs.sh
#!/bin/bash
aws s3 cp /var/log/cloud-init.log s3://${BUCKET_NAME}/logs/system/
aws s3 cp /app/logs/ s3://${BUCKET_NAME}/logs/app/ --recursive
EOT

chmod +x /usr/local/bin/upload-logs.sh

# Systemd service to upload logs on shutdown
cat <<EOT > /etc/systemd/system/upload-logs.service
[Unit]
Description=Upload logs to S3 on shutdown
DefaultDependencies=no
Before=shutdown.target reboot.target halt.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/upload-logs.sh
RemainAfterExit=true

[Install]
WantedBy=halt.target reboot.target shutdown.target
EOT

systemctl enable upload-logs.service
