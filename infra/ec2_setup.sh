#!/bin/bash
apt-get update -y
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
usermod -a -G docker ubuntu
docker pull rauljyoti/motivation-web-app:latest