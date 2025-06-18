#!/bin/bash

# Update & install dependencies
apt update -y
apt upgrade -y

# Install Docker
apt install -y docker.io
usermod -aG docker ubuntu
systemctl enable docker
systemctl start docker

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install unzip -y
unzip -q awscliv2.zip
sudo ./aws/install

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Update kubeconfig for EKS
aws eks --region ap-south-1 update-kubeconfig --name my-eks-cluster

# Deploy NGINX Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/aws/deploy.yaml

# Wait for NGINX to be ready
echo "Waiting for NGINX Ingress Controller..."
kubectl rollout status deployment ingress-nginx-controller -n ingress-nginx

# Add Prometheus and Grafana Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Create namespace for monitoring
kubectl create namespace monitoring

# Install Prometheus
helm install prometheus prometheus-community/prometheus \
  --namespace monitoring

# Install Grafana
helm install grafana grafana/grafana \
  --namespace monitoring \
  --set adminPassword='admin' \
  --set service.type=LoadBalancer

# Wait for Grafana to be ready
echo "Waiting for Grafana service..."
kubectl rollout status deployment grafana -n monitoring

echo "setup completed Successfully"
