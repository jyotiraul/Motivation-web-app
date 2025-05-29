#!/bin/bash
apt-get update -y
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
usermod -a -G docker ubuntu
docker pull rauljyoti/motivation-web-app:latest
docker stop motivation-web || true
docker rm motivation-web || true
docker run -d --name motivation-web -p 5000:5000 rauljyoti/motivation-web-app:latest