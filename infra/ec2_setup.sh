#!/bin/bash
set -e

# Redirect all output to a log file for debugging
exec > /var/log/user-data.log 2>&1

echo "Starting EC2 user-data script..."

echo "Updating package list and installing Docker..."
apt-get update -y
apt-get install -y docker.io

echo "Starting and enabling Docker service..."
systemctl start docker
systemctl enable docker

echo "Adding ubuntu user to the docker group..."
usermod -a -G docker ubuntu

echo "Pulling latest Docker image..."
docker pull rauljyoti/motivation-web-app:latest

echo "Stopping any running containers using this image..."
docker ps -q --filter ancestor=rauljyoti/motivation-web-app:latest | xargs -r docker stop || true

echo "Running the Docker container..."
docker run -d -p 5000:5000 rauljyoti/motivation-web-app:latest

echo "EC2 setup script completed successfully."
