#!/bin/bash
# Update and install dependencies
sudo apt-get update -y
sudo apt-get install -y openjdk-21-jdk git maven

# Clone the repo
cd /home/ubuntu
git clone https://github.com/Trainings-TechEazy/test-repo-for-devops.git
cd test-repo-for-devops

# Build project
mvn clean package -DskipTests

# Run application in background
nohup java -jar target/techeazy-devops-0.0.1-SNAPSHOT.jar > app.log 2>&1 &
