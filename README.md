# Motivation Web App

A motivational web application built with Flask, containerized using Docker, and deployable on AWS with Terraform and on local Kubernetes with Minikube.

---

## 📦 Clone the Repository

```bash
git clone https://github.com/sparknet-innovations/motivation-web-app.git
cd motivation-web-app
````

---

## 🐳 Docker Instructions

### 1. Create Dockerfile

```bash
# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt /app/
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Copy the whole project
COPY . /app/

# Expose the port Gunicorn will run on
EXPOSE 5000

# Command to run the application using Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "run:app"]
````

### 2. Build Docker Image

```bash
docker build -t motivation-web-app .
```

---
### 3. Verify Docker Image

```bash
docker images
```

### 4. Run Docker Image Locally

```bash
docker run -p 5000:5000 motivation-web-app
```

![image](https://github.com/user-attachments/assets/df7184d4-f838-4d0b-92c5-2f06265eec28)


---

## ☁️ Push Image to Docker Hub

### 1. Login to Docker

```bash
docker login
```

### 2. Tag and Push the Image

```bash
docker tag motivation-web-app rauljyoti/motivation-web-app:latest
docker push rauljyoti/motivation-web-app:latest
```

---

## 📥 Pull and Run from Docker Hub (to check image is working or not)

```bash
docker pull rauljyoti/motivation-web-app:latest
docker run -d -p 5000:5000 rauljyoti/motivation-web-app:latest
```

---

## 📷 Application Preview

![image](https://github.com/user-attachments/assets/c9d34f1c-f4c7-4f7d-98a4-6c91141560fd)


---

## ⚙️ Infrastructure as Code (Terraform)

### `main.tf`

```hcl
provider "aws" {
  region = "ap-south-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_subnet" "public_1a" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "motivation-subnet-1a"
  }
}

resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }

  tags = {
    Name = "motivation-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "motivation_sg" {
  name        = "motivation-web-sg"
  description = "Allow SSH and web traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "motivation_app" {
  ami                    = "ami-0f5ee92e2d63afc18"
  instance_type          = "t2.micro"
  key_name               = "lab3"
  subnet_id              = aws_subnet.public_1a.id
  user_data              = file("ec2_setup.sh")
  vpc_security_group_ids = [aws_security_group.motivation_sg.id]

  tags = {
    Name = "MotivationWebApp"
  }
}
```

### `output.tf`

```hcl
output "public_ip" {
  value = aws_instance.motivation_app.public_ip
}
```

### `variables.tf`

```hcl
variable "key_name" {
  description = "Name of your existing EC2 Key Pair"
  type        = string
}
```

### `ec2_setup.sh`

```bash
#!/bin/bash
apt-get update -y
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
usermod -a -G docker ubuntu
docker run -d -p 5000:5000 rauljyoti/motivation-web-app:latest
```

---

## 🚀 Deploy with Terraform

```bash
cd infra
terraform init
terraform plan
terraform apply
```

### 🔐 SSH into EC2

```bash
ssh -i /path/to/your-key.pem ubuntu@<public-ip>
```

### 🌐 Access the Web App

Open your browser and go to:

```text
http://<your_ip-address>:5000/
```
![image](https://github.com/user-attachments/assets/bb8c87d7-c569-4424-bcfd-193345aa3950)

---

## 🧪 Local Kubernetes Deployment using Minikube

### Start Minikube

```bash
minikube start
```

### Build Docker Image Inside Minikube

```bash
eval $(minikube docker-env)
docker build -t motivation-app:latest .
```

### Apply Kubernetes Manifests

```bash
kubectl apply -f deployment.yml
kubectl apply -f service.yml
kubectl apply -f ingress.yml
```

### Verify Resources

```bash
kubectl get pods
kubectl get svc
minikube service motivation-service
```
![image](https://github.com/user-attachments/assets/7ded7e80-2557-46bc-9e79-264f316401c7)

---
![image](https://github.com/user-attachments/assets/2fff1c39-1300-40ea-be9d-33186780fdd4)


---
