
Deployment using terraform (AWS), ansible, github action, GitHub Webhook Listener- CI/CD

Step 1: 
create ec2 using terraform and ssh to ec2
ssh -i "C:\Users\THE SHIKSHAK\Downloads\lab3.pem" ubuntu@ip_address

Step 2:
# Download Ansible playbook
sudo apt-get update
sudo apt-get install ansible  #install ansible 
ansible --version  #check  version

Project structure look like: 
/home/ubuntu/
├── ansible/
│   ├── inventory
│   ├── playbook.yml
│   └── files/
│       └── flaskapp.service

#Check file 
(changes in run.py -- >  app.run(host='0.0.0.0', port=5000, debug=True) ) 

Step 3:
inventory   (copy and paste file from local to remote (ec2 server))
playbook.yml  (copy and paste file from local to remote (ec2 server))
files/flaskapp.service      (create /etc/systemd/system/flaskapp.service)
sudo systemctl daemon-reload
sudo systemctl enable flaskapp
sudo systemctl restart flaskapp

## configuration of github action workflow (CI/CD)
*************************************************
Step 4: 
1. Generate SSH Key (On your local machine)
ssh-keygen -t rsa -b 4096 -C "github-actions" -f deploy_key
Note: deploy_key (private key) & deploy_key.pub (public key)

2. Add the Public Key to EC2
(On your EC2 instance) : 
cat deploy_key.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/deploy_key

3. Add the Private Key to GitHub Secrets
Go to Settings > Secrets and Variables > Actions
Add new repository secrets:
DEPLOY_KEY → contents of deploy_key (private key)
HOST → 13.201.32.188 (your ec2 key)
USER → ubuntu

Step 5:
GitHub Actions Workflow (.github/workflows/deploy.yml) 

4. Create file in your repo: .github/workflows/deploy.yml
.github/workflows/deploy.yml

Step 6: 
cd ~/ansible
ansible-playbook -i inventory playbook.yml

Step 7:
#restart the app 
sudo systemctl daemon-reload
sudo systemctl restart flaskapp
sudo systemctl status flaskapp

http://13.201.32.188:5000 

Note: 
(if getting error, check is any service running-> sudo lsof -i :5000
if yes then -> sudo kill -9 ***4)

if error check file location --ls /opt/motivation-app/
sudo journalctl -u flaskapp.service -n 50 --no-pager

************************************************************************************************************
#Ansible pulls your latest app and redeploys it with systemd.

Step 8: 
#Install GitHub Webhook Listener 
sudo apt update
sudo apt install webhook -y

Step 9: 
#create hook script 
sudo mkdir -p /etc/webhook
sudo nano /etc/webhook/hooks.json (copy from - webhook_files/hooks.json)
sudo nano /etc/webhook/deploy.sh (copy from - webhook_files/deploy.sh)

sudo chmod +x /etc/webhook/deploy.sh (make executable)

step 10: 
#In your EC2 security group, open port 9000 for your IP or GitHub IP range only (for security).
http://13.127.194.99:9000/   #running ok means service is up and running correctly.

Step 11: 
#add github webhook
payload url ->  http://<YOUR_EC2_PUBLIC_IP>:9000/hooks/deploy-flask
Content type: application/json
Secret: Same as YourGitHubSecretHere in hooks.json  (secret will be any random key)
Select “Just the push event” → Save

Step 12:
(Recommanded)
sudo chown -R ubuntu:ubuntu /opt/motivation-app
cd /opt/motivation-app
git pull origin main  #just check is it work or not. 
        Or another option 
add github action file in Pull latest code on EC2 and restart Flask app: git config --global --add safe.directory /opt/motivation-app

Step 13:
# Start the Webhook Listener
: Run webhook as a systemd service (running on background)
sudo nano /etc/systemd/system/webhook.service  (code copy from ansible/webhook_files/webhook.service)
#then run :
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable webhook
sudo systemctl start webhook
sudo systemctl status webhook

Step 14: 
Make a code change in GitHub
Push it to main
#GitHub webhook will fire → EC2 pulls + deploys via Ansible!

Done. 

*********************************************************************************************
#check logs 
/var/log/deploy.log
tail -f /var/log/motivation-deploy.log
sudo systemctl status flaskapp
sudo systemctl restart flaskapp
sudo lsof -i :5000   Note: You should see *:5000 (LISTEN) instead of localhost:5000.


Key scp :
scp -i "C:\Users\THE SHIKSHAK\Downloads\lab3.pem" "C:\assignment\M
otivation-web-app\motivation-web-app\infra\deploy_key" ubuntu@13.232.58.124:/home/ubuntu/.ssh/deploy_key

chmod 600 ~/.ssh/deploy_key   (ec2 private key)

cat deploy_key.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys  (ec2 public key)

