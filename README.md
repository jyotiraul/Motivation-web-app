# CI/CD Pipeline Deployment Using Terraform, Ansible, GitHub Actions & Webhooks

This guide walks through the deployment of a Flask web application using Terraform, Ansible, GitHub Actions, and a GitHub Webhook listener for full CI/CD integration on AWS EC2.

---

## 🛠️ Technologies Used

- **Terraform**: Provision AWS EC2 instances
- **Ansible**: Configuration management and deployment
- **GitHub Actions**: CI/CD automation
- **GitHub Webhooks**: Trigger deployments on push

---

## 📌 Project Structure

/home/ubuntu/
├── ansible/
│   ├── inventory
│   ├── playbook.yml
│   └── files/
│       └── flaskapp.service

---

## 🚀 Deployment Steps

### Step 1: Provision EC2 with Terraform
- Run Terraform script to launch an EC2 instance.
- SSH into EC2:

```bash
ssh -i "C:\Users\THE SHIKSHAK\Downloads\lab3.pem" ubuntu@<EC2_PUBLIC_IP>
```

---

### Step 2: Install Ansible on EC2

```bash
sudo apt-get update
sudo apt-get install ansible
ansible --version
```

Update your Flask app to run on public IP:

```python
# run.py
app.run(host='0.0.0.0', port=5000, debug=True)
```

---

### Step 3: Copy Ansible Files to EC2

Transfer the following to `/home/ubuntu/ansible`:
- `inventory`
- `playbook.yml`
- `files/flaskapp.service`

Deploy with Ansible:

```bash
cd ~/ansible
ansible-playbook -i inventory playbook.yml
```

Manage the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable flaskapp
sudo systemctl restart flaskapp
```

---

## ⚙️ GitHub Actions Configuration (CI/CD)

### Step 4: SSH Key Generation (on local machine)

```bash
ssh-keygen -t rsa -b 4096 -C "github-actions" -f deploy_key
```

- Copy `deploy_key.pub` to EC2:

```bash
cat deploy_key.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/deploy_key
```

### Step 5: Add GitHub Secrets

In your GitHub repo:

- `DEPLOY_KEY`: contents of `deploy_key`
- `HOST`: EC2 public IP (e.g., `13.201.32.188`)
- `USER`: `ubuntu`

### Step 6: GitHub Actions Workflow

Create file `.github/workflows/deploy.yml` in your repo to define your deployment workflow.

---

## 🪝 GitHub Webhook Listener

### Step 7: Install Webhook on EC2

```bash
sudo apt update
sudo apt install webhook -y
```

### Step 8: Create Hook Script

```bash
sudo mkdir -p /etc/webhook
sudo nano /etc/webhook/hooks.json     # Use content from webhook_files/hooks.json
sudo nano /etc/webhook/deploy.sh      # Use content from webhook_files/deploy.sh
sudo chmod +x /etc/webhook/deploy.sh
```

### Step 9: Open Port 9000 in EC2 Security Group

Verify webhook is running:
```bash
http://<EC2_PUBLIC_IP>:9000/
```

### Step 10: Configure GitHub Webhook

- **Payload URL**: `http://<EC2_PUBLIC_IP>:9000/hooks/deploy-flask`
- **Content Type**: `application/json`
- **Secret**: Same as in `hooks.json`
- **Event**: Just the push event

---

### Step 11: Start Webhook as a Service

```bash
sudo nano /etc/systemd/system/webhook.service
# Paste content from ansible/webhook_files/webhook.service

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable webhook
sudo systemctl start webhook
sudo systemctl status webhook
```

---

## ✅ Test the CI/CD Pipeline

1. Push a code change to the `main` branch on GitHub.
2. GitHub Webhook triggers EC2 deployment via Ansible.

---

## 🔧 Troubleshooting

- Check service status:
  ```bash
  sudo systemctl status flaskapp
  ```
- Restart app:
  ```bash
  sudo systemctl restart flaskapp
  ```
- View logs:
  ```bash
  sudo journalctl -u flaskapp.service -n 50 --no-pager
  tail -f /var/log/motivation-deploy.log
  ```
- Check port:
  ```bash
  sudo lsof -i :5000
  ```
- Kill conflicting process:
  ```bash
  sudo kill -9 <PID>
  ```

---

## 🔐 Key Transfer Commands

```bash
scp -i "C:\Users\THE SHIKSHAK\Downloads\lab3.pem" "C:\assignment\Motivation-web-app\motivation-web-app\infra\deploy_key" ubuntu@<EC2_PUBLIC_IP>:/home/ubuntu/.ssh/deploy_key

# Set permissions on EC2
chmod 600 ~/.ssh/deploy_key
cat deploy_key.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

---

