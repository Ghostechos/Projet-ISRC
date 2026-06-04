#!/bin/bash
set -e

# Fix DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo ">>> Terraform apply..."
cd /opt/Projet-ISRC/terraform
terraform apply -parallelism=1 -auto-approve

echo ">>> Push GitHub..."
cd /opt/Projet-ISRC
git add .
git commit -m "Auto-deploy — $(date '+%Y-%m-%d %H:%M')" || echo "Rien à committer"
git push origin main

echo ">>> Ansible deploy..."
cd /opt/Projet-ISRC
ansible-playbook -i /opt/Projet-ISRC/ansible/inventory.ini \
  /opt/Projet-ISRC/ansible/playbook.yml \
  --private-key /root/.ssh/id_ed25519_isrc

echo ">>> DONE !"
