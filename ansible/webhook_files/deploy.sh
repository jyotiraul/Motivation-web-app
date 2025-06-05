#!/bin/bash

echo "[$(date)] Starting deployment..." >> /var/log/motivation-deploy.log

cd /opt/motivation-app || exit 1
git pull origin main >> /var/log/motivation-deploy.log 2>&1

# Run Ansible playbook to restart the app
ansible-playbook -i inventory playbook.yml >> /var/log/motivation-deploy.log 2>&1

echo "[$(date)] Deployment completed." >> /var/log/motivation-deploy.log