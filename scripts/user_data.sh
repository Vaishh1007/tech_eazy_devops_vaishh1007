#!/bin/bash
# EC2 bootstrap script for Assignment 3

# Update system
yum update -y

# Install dependencies
yum install -y docker git python3 awscli

# Start & enable Docker
systemctl start docker
systemctl enable docker

# Create app directory & logs
mkdir -p /app/logs
echo "App started on $(date)" >> /app/logs/app.log
echo "Hello from Assignment 3 Web App" > /app/index.html

# Start a simple HTTP server on port 80
nohup python3 -m http.server 80 --directory /app > /app/logs/web.log 2>&1 &

# Create log upload script
cat << 'EOF' > /usr/local/bin/upload-logs.sh
#!/bin/bash
aws s3 cp /var/log/cloud-init.log s3://${bucket_name}/logs/system/
aws s3 cp /app/logs/ s3://${bucket_name}/logs/app/ --recursive
EOF

chmod +x /usr/local/bin/upload-logs.sh

# Create systemd service file for log upload
cat << 'EOF' > /etc/systemd/system/upload-logs.service
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
EOF

# Enable the shutdown service
systemctl enable upload-logs.service
