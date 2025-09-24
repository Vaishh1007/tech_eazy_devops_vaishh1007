#!/bin/bash
# Script to install Docker and Node.js on EC2
sudo yum update -y
sudo yum install -y docker git
sudo systemctl start docker
sudo systemctl enable docker
