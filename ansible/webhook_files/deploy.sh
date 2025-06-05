#!/bin/bash
cd /opt/motivation-app
git pull origin main
ansible-playbook -i ansible/inventory ansible/playbook.yml
