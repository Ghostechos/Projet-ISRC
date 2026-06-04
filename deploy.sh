#!/bin/bash
set -e

echo ">>> Terraform apply..."
cd /opt/Projet-ISRC/terraform
terraform apply -parallelism=1 -auto-approve

echo ">>> Push GitHub..."
cd /opt/Projet-ISRC
git add .
git commit -m "Auto-deploy — $(date '+%Y-%m-%d %H:%M')" || echo "Rien à committer"
git push origin main

echo ">>> Ansible deploy..."
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml \
  --private-key /root/.ssh/id_ed25519_isrc

echo ">>> DONE !"
