#!/bin/bash
set -e

# Fix DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo ">>> Terraform apply..."
cd /opt/Projet-ISRC/terraform
terraform apply -parallelism=1 -auto-approve

echo ">>> Détection des IPs des VMs..."

# Plages IP par VLAN
VLAN20="192.168.20"
VLAN30="192.168.30"
VLAN40="192.168.40"

find_ip() {
    local range=$1
    for i in $(seq 1 254); do
        ip="${range}.${i}"
        if ping -c 1 -W 1 $ip > /dev/null 2>&1; then
            echo $ip
            return
        fi
    done
    echo ""
}

echo "  Scan VLAN 20 pour srv-web..."
IP_WEB=$(find_ip $VLAN20)
echo "  Scan VLAN 20 pour srv-db..."
IP_DB=$(find_ip $VLAN20)
echo "  Scan VLAN 30 pour srv-wazuh..."
IP_WAZUH=$(find_ip $VLAN30)
echo "  Scan VLAN 30 pour srv-graylog..."
IP_GRAYLOG=$(find_ip $VLAN30)
echo "  Scan VLAN 40 pour srv-ia..."
IP_IA=$(find_ip $VLAN40)

echo ""
echo "  IPs détectées :"
echo "  srv-wazuh   : $IP_WAZUH"
echo "  srv-graylog : $IP_GRAYLOG"
echo "  srv-ia      : $IP_IA"

echo ">>> Mise à jour inventory.ini..."
cat > /opt/Projet-ISRC/ansible/inventory.ini << INVENTORY
[vlan20]
$([ -n "$IP_WEB" ] && echo "srv-web     ansible_host=$IP_WEB" || echo "# srv-web non joignable")
$([ -n "$IP_DB" ] && echo "srv-db      ansible_host=$IP_DB" || echo "# srv-db non joignable")

[vlan30]
$([ -n "$IP_WAZUH" ] && echo "srv-wazuh   ansible_host=$IP_WAZUH" || echo "# srv-wazuh non joignable")
$([ -n "$IP_GRAYLOG" ] && echo "srv-graylog ansible_host=$IP_GRAYLOG" || echo "# srv-graylog non joignable")

[vlan40]
$([ -n "$IP_IA" ] && echo "srv-ia      ansible_host=$IP_IA" || echo "# srv-ia non joignable")

[all_vms:children]
vlan20
vlan30
vlan40

[all_vms:vars]
ansible_user=debian
ansible_ssh_private_key_file=/root/.ssh/id_ed25519_isrc
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o BindAddress=192.168.50.21'
ansible_python_interpreter=/usr/bin/python3
INVENTORY

echo ">>> Push GitHub..."
cd /opt/Projet-ISRC
git add .
git commit -m "Auto-deploy — $(date '+%Y-%m-%d %H:%M')" || echo "Rien à committer"
git push origin main

echo ">>> Ansible deploy (uniquement les VMs joignables)..."
cd /opt/Projet-ISRC
ansible-playbook -i /opt/Projet-ISRC/ansible/inventory.ini \
  /opt/Projet-ISRC/ansible/playbook.yml \
  --private-key /root/.ssh/id_ed25519_isrc \
  --limit all_vms \
  -v

echo ">>> DONE !"
