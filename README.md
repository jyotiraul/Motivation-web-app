
# Empowerment Hub

A Flask-based Motivational Web Application implementing DevOps methodologies including containerization, Infrastructure as Code (IaC), CI/CD, Kubernetes deployment, and cloud monitoring.

---

## 📁 Project Structure

```
motivation-web-app
├── app
│   ├── __init__.py
│   ├── routes.py
│   ├── templates
│   │   ├── base.html
│   │   ├── index.html
│   │   ├── about.html
│   │   ├── quotes.html
│   │   ├── blog.html
│   │   └── contact.html
│   └── static
│       ├── css
│       │   └── styles.css
│       └── js
├── deploy/                 
│   ├── deployment.yml
│   ├── service.yml
│   └── ingress.yml
├── infra/                  
│   ├── ec2_setup.sh         
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── jenkins/                
│   ├── Jenkinsfile
│   └── Dockerfile
├── .gitignore              
├── Dockerfile              
├── requirements.txt    
├── run.py
└── README.md
```

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
| Monitoring       | AWS CloudWatch   |
| VCS & IDE        | Git, GitHub, VS Code |

---

## 🛠️ Setup & Installation

### 🔹 Local Setup

```bash
git clone https://github.com/sparknet-innovations/motivation-web-app.git
cd motivation-web-app

python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

pip install -r requirements.txt
python run.py
```

Visit: [http://127.0.0.1:5000](http://127.0.0.1:5000)

---

## 🐳 Dockerization

### 🔹 Build and Run

```bash
docker build -t motivation-web-app .
docker run -p 5000:5000 motivation-web-app
```

### 🔹 Push to Docker Hub

```bash
docker login
docker tag motivation-web-app rauljyoti/motivation-web-app:latest
docker push rauljyoti/motivation-web-app:latest
```

### 🔹 Pull and Verify

```bash
docker pull rauljyoti/motivation-web-app:latest
docker run -d -p 5000:5000 rauljyoti/motivation-web-app:latest
```

---

## ☸️ Kubernetes Deployment

Ensure Docker Desktop and Minikube are running.

```bash
minikube start

kubectl apply -f deployment.yml
kubectl apply -f service.yml
kubectl apply -f ingress.yml

minikube service motivation-service
```

---

## ⚙️ CI/CD Pipeline

### 🔹 Infrastructure as Code (Terraform)

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

---

### 🔹 Jenkins Setup

```bash
docker build -t my-jenkins-docker ./jenkins

docker run -d --name jenkins \
  -p 9090:8080 -p 50000:50000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v jenkins_home:/var/jenkins_home \
  my-jenkins-docker
```

Access Jenkins: [http://localhost:9090](http://localhost:9090)

### 🔹 Required Plugins

- Git Plugin
- Docker Pipeline
- Pipeline Utility Steps
- AWS Credentials Plugin
- Workspace Cleanup Plugin
- SSH Agent Plugin

### 🔹 Required Credentials

- DockerHub login
- GitHub personal access token
- AWS access keys
- EC2 SSH key

### 🔹 GitHub Webhook Integration (via ngrok)

```bash
choco install ngrok
ngrok config add-authtoken <your_token>
ngrok http http://localhost:9090
```

Set the webhook in your GitHub repo:
- Go to **Settings** > **Webhooks** > **Add webhook**
- Payload URL: your ngrok tunnel
- Content type: `application/json`

### 🔹 Jenkins Pipeline Configuration

Create a new Jenkins Pipeline project:
- Enable **GitHub hook trigger for GITScm polling**
- Use the script from `jenkins/Jenkinsfile`
- Replace `EC2_PUBLIC_IP` with the public IP output from Terraform

---

## 📈 Monitoring & Logs

### 🔹 AWS CloudWatch Integration

AWS CloudWatch is used for comprehensive application observability, including:

- Real-time log streaming
- Error tracking and alerts
- Performance metrics and analysis

Navigate in AWS:
```
CloudWatch → Logs → Log groups → [Your Application Group]
```

---
