# Empowerment Hub

A Flask-based Motivational Web Application implementing DevOps methodologies such as containerization, IaC, CI/CD, Kubernetes deployment, and cloud monitoring.

## 🚀 Project Objective

To develop, containerize, and deploy a motivational web application using modern DevOps practices:

- Version Control (Git/GitHub)
- Docker-based containerization
- Infrastructure as Code (Terraform)
- Kubernetes Deployment (Minikube)
- CI/CD Pipelines (Jenkins)
- Cloud Monitoring (AWS CloudWatch)

## 🌐 Live Demo

**Deployed Application:** [http://13.232.183.230:5000](http://13.232.183.230:5000)

**GitHub Repository:** [sparknet-motivation-web-app](https://github.com/jyotiraul/sparknet-motivation-web-app.git)

---

## 🧰 Tech Stack

| Component        | Technology       |
|------------------|------------------|
| Web Framework    | Flask (Python)   |
| UI               | HTML5, CSS3, JavaScript |
| Containerization | Docker           |
| Orchestration    | Kubernetes (Minikube) |
| CI/CD            | Jenkins          |
| IaC              | Terraform        |
| Cloud Platform   | AWS (EC2, CloudWatch) |
| Monitoring       | CloudWatch       |
| VCS & IDE        | Git, GitHub, VS Code |

---

## 📂 Application Structure

- **Home**: Landing page with motivational messaging.
- **About**: Application overview.
- **Quotes**: Inspirational quote collection.
- **Blog**: Growth and self-development articles.
- **Contact**: Feedback and suggestions form.

---

## 🛠️ Setup & Installation

### 1️⃣ Local Setup

```bash
# Clone the repository
git clone https://github.com/sparknet-innovations/motivation-web-app.git
cd motivation-web-app

# Create and activate virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the app
python run.py

# Access the app
Visit http://127.0.0.1:5000
```

---

## 🐳 Dockerization

### Dockerfile Overview

- **Base Image**: `python:3.10-slim`
- **Web Server**: Gunicorn
- **Port**: 5000

### Build & Run

```bash
# Build Docker image
docker build -t motivation-web-app .

# Run container
docker run -p 5000:5000 motivation-web-app
```

### Docker Hub

```bash
# Push to Docker Hub
docker login
docker tag motivation-web-app rauljyoti/motivation-web-app:latest
docker push rauljyoti/motivation-web-app:latest

# Pull and run from Docker Hub
docker pull rauljyoti/motivation-web-app:latest
docker run -d -p 5000:5000 rauljyoti/motivation-web-app:latest
```

---

## ☸️ Kubernetes Deployment

Ensure Minikube and Docker Desktop are running.

```bash
# Start Minikube
minikube start

# Apply Kubernetes configs
kubectl apply -f deployment.yml
kubectl apply -f service.yml
kubectl apply -f ingress.yml

# Access service
minikube service motivation-service
```

---

## ⚙️ CI/CD with Jenkins

### Jenkins Setup

- Build Jenkins image:
  ```bash
  docker build -t my-jenkins-docker ./jenkins
  ```

- Run Jenkins container:
  ```bash
  docker run -d --name jenkins \
    -p 9090:8080 -p 50000:50000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v jenkins_home:/var/jenkins_home \
    my-jenkins-docker
  ```

- Access Jenkins: [http://localhost:9090](http://localhost:9090)

### Plugins Required

- Git Plugin
- Docker Pipeline
- Pipeline Utility Steps
- AWS Credentials Plugin
- Workspace Cleanup Plugin
- SSH Agent Plugin

### Webhook Integration with GitHub (via Ngrok)

```bash
choco install ngrok
ngrok config add-authtoken <your_token>
ngrok http http://localhost:9090
```

Update GitHub webhook with ngrok URL.

### Jenkinsfile Configuration

Create a pipeline job and use the `jenkins/Jenkinsfile`. Update:
```groovy
environment {
  EC2_PUBLIC_IP = '<Your EC2 IP>'
}
```

---

## ☁️ Infrastructure as Code (Terraform)

### Files

- `main.tf`: Defines infrastructure resources (EC2, CloudWatch).
- `variables.tf`: Input variable declarations.
- `outputs.tf`: Outputs (e.g., EC2 public IP).

### Commands

```bash
terraform init       # Initialize Terraform
terraform validate   # Validate configuration
terraform plan       # Preview changes
terraform apply      # Apply configuration
```

---

## 📈 Monitoring & Logs

AWS CloudWatch integration for:

- Logs
- Error tracking
- Performance monitoring

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙌 Acknowledgements

Inspired by self-growth and DevOps principles, this app serves as a full-stack DevOps demonstration.
