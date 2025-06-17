# Empowerment Hub

A Flask-based Motivational Web Application implementing DevOps methodologies such as containerization, IaC, CI/CD, Kubernetes deployment, and cloud monitoring.

## 📁 Project Structure

```
motivation-web-app
├── .github
|   ├──workflows
|       ├──deploy.yaml
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
├── certificate
|   └── cluster-issuer.yaml
├── k8s/                 # Kubernetes deployment files
│   └── deployment.yml
|   ├── service.yml
|   └── ingress.yml
├── infra/                   # Infrastructure as Code (Terraform)
|   └── ec2_setup.sh         
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── .gitignore              # Git ignore rules
├── Dockerfile              # Docker container- flask application
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
| Monitoring       | CloudWatch       |
| VCS & IDE        | Git, GitHub, VS Code |

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

###  Dockerization of the Flask Application 

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

# Pull and run from Docker Hub (Verify image)
docker pull rauljyoti/motivation-web-app:latest
docker run -d -p 5000:5000 rauljyoti/motivation-web-app:latest
```

---

## ☸️ Deploy to Production-Level Kubernetes (EKS)
 
 