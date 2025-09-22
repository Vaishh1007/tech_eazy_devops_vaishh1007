#!/bin/bash
# Variables passed via Terraform environment
export STAGE=${stage:-dev}
export SHUTDOWN_MINUTES=${shutdown_minutes:-0}

# Update system and install dependencies
apt-get update -y
apt-get install -y openjdk-21-jdk maven git nginx

# Optional auto-shutdown
if [ "$SHUTDOWN_MINUTES" != "0" ]; then
  shutdown -h +$SHUTDOWN_MINUTES &
fi

# Clone TechEazy sample app
cd /home/ubuntu
git clone https://github.com/Trainings-TechEazy/test-repo-for-devops.git
cd test-repo-for-devops

# Select config based on stage
if [ "$STAGE" = "prod" ]; then
  cp ../configs/prod_config.properties application.properties
else
  cp ../configs/dev_config.properties application.properties
fi

# Build app
mvn clean package -DskipTests

# Run app in background
nohup java -jar target/techeazy-devops-0.0.1-SNAPSHOT.jar --server.port=8080 > app.log 2>&1 &

# Configure Nginx reverse proxy to port 80
cat > /etc/nginx/sites-available/techeazy <<EOL
server {
    listen 80;
    location / {
        proxy_pass http://127.0.0.1:8080;
    }
}
EOL
ln -s /etc/nginx/sites-available/techeazy /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
systemctl restart nginx
