#!/bin/bash
# EC2 bootstrap script for Assignment 2

# Update system
yum update -y

# Install dependencies
yum install -y docker git awscli

# Start & enable Docker
systemctl start docker
systemctl enable docker

# Create app logs directory
mkdir -p /app/logs
echo "App started on $(date)" >> /app/logs/app.log

# Create log upload script
echo '#!/bin/bash' > /usr/local/bin/upload-logs.sh
echo 'aws s3 cp /var/log/cloud-init.log s3://vaishh-assignment2-bucket-123/logs/system/' >> /usr/local/bin/upload-logs.sh
echo 'aws s3 cp /app/logs/ s3://vaishh-assignment2-bucket-123/logs/app/ --recursive' >> /usr/local/bin/upload-logs.sh

chmod +x /usr/local/bin/upload-logs.sh

# Create systemd service file
echo '[Unit]' > /etc/systemd/system/upload-logs.service
echo 'Description=Upload logs to S3 on shutdown' >> /etc/systemd/system/upload-logs.service
echo 'DefaultDependencies=no' >> /etc/systemd/system/upload-logs.service
echo 'Before=shutdown.target reboot.target halt.target' >> /etc/systemd/system/upload-logs.service
echo '' >> /etc/systemd/system/upload-logs.service
echo '[Service]' >> /etc/systemd/system/upload-logs.service
echo 'Type=oneshot' >> /etc/systemd/system/upload-logs.service
echo 'ExecStart=/usr/local/bin/upload-logs.sh' >> /etc/systemd/system/upload-logs.service
echo 'RemainAfterExit=true' >> /etc/systemd/system/upload-logs.service
echo '' >> /etc/systemd/system/upload-logs.service
echo '[Install]' >> /etc/systemd/system/upload-logs.service
echo 'WantedBy=halt.target reboot.target shutdown.target' >> /etc/systemd/system/upload-logs.service

# Enable the service
systemctl enable upload-logs.service
