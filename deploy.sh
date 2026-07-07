#!/bin/bash
set -e

# Fix DNS
if [ -w /etc/resolv.conf ]; then
    echo "nameserver 8.8.8.8" > /etc/resolv.conf
else
    echo ">>> Impossible de modifier /etc/resolv.conf, on continue..."
fi

echo ">>> Recherche des VMID libres..."

USED_VMIDS=$(qm list | awk 'NR>1 {print $1}')

find_free_vmid() {
    local id=$1
    while echo "$USED_VMIDS" | grep -q "^${id}$"; do
        id=$((id+1))
    done
    echo "$id"
}

VMID_WAZUH=$(find_free_vmid 105)
USED_VMIDS="$USED_VMIDS
$VMID_WAZUH"

VMID_GRAYLOG=$(find_free_vmid 106)
USED_VMIDS="$USED_VMIDS
$VMID_GRAYLOG"

VMID_IA=$(find_free_vmid 107)
USED_VMIDS="$USED_VMIDS
$VMID_IA"

cat > /opt/Projet-ISRC/terraform/terraform.auto.tfvars << EOF
vmid_wazuh   = $VMID_WAZUH
vmid_graylog = $VMID_GRAYLOG
vmid_ia      = $VMID_IA
EOF

echo "VMID Wazuh   : $VMID_WAZUH"
echo "VMID Graylog : $VMID_GRAYLOG"
echo "VMID IA      : $VMID_IA"

echo ">>> Terraform apply..."
cd /opt/Projet-ISRC/terraform
terraform apply -parallelism=1 -auto-approve

echo ">>> Détection des IPs des VMs..."

VLAN20="192.168.20"
VLAN30="192.168.30"
VLAN40="192.168.40"

find_ip() {
    local range=$1
    for i in $(seq 1 254); do
        ip="${range}.${i}"
        if ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
            echo "$ip"
            return
        fi
    done
    echo ""
}

echo "  Scan VLAN 20 pour SRV-VM-WEB..."
IP_WEB=$(find_ip "$VLAN20")

echo "  Scan VLAN 20 pour SRV-VM-DB..."
IP_DB=$(find_ip "$VLAN20")

echo "  Scan VLAN 30 pour SRV-VM-WAZUH..."
IP_WAZUH=$(find_ip "$VLAN30")

echo "  Scan VLAN 30 pour SRV-VM-GRAYLOG..."
IP_GRAYLOG=$(find_ip "$VLAN30")

echo "  Scan VLAN 40 pour SRV-VM-IA..."
IP_IA=$(find_ip "$VLAN40")

echo ""
echo "IPs détectées :"
echo "SRV-VM-WAZUH   : $IP_WAZUH"
echo "SRV-VM-GRAYLOG : $IP_GRAYLOG"
echo "SRV-VM-IA      : $IP_IA"

echo ">>> Mise à jour inventory.ini..."

cat > /opt/Projet-ISRC/ansible/inventory.ini << EOF
[vlan20]
$([ -n "$IP_WEB" ] && echo "SRV-VM-WEB ansible_host=$IP_WEB" || echo "# SRV-VM-WEB non joignable")
$([ -n "$IP_DB" ] && echo "SRV-VM-DB ansible_host=$IP_DB" || echo "# SRV-VM-DB non joignable")

[vlan30]
$([ -n "$IP_WAZUH" ] && echo "SRV-VM-WAZUH ansible_host=$IP_WAZUH" || echo "# SRV-VM-WAZUH non joignable")
$([ -n "$IP_GRAYLOG" ] && echo "SRV-VM-GRAYLOG ansible_host=$IP_GRAYLOG" || echo "# SRV-VM-GRAYLOG non joignable")

[vlan40]
$([ -n "$IP_IA" ] && echo "SRV-VM-IA ansible_host=$IP_IA" || echo "# SRV-VM-IA non joignable")

[all_vms:children]
vlan20
vlan30
vlan40

[all_vms:vars]
ansible_user=debian
ansible_ssh_private_key_file=/root/.ssh/id_ed25519_isrc
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o BindAddress=192.168.50.21'
ansible_python_interpreter=/usr/bin/python3
EOF

echo ">>> Push GitHub..."

cd /opt/Projet-ISRC

git add .
git commit -m "Auto-deploy - $(date '+%Y-%m-%d %H:%M')" || echo "Rien à committer"
git push origin main

echo ">>> Attente des VMs..."

ansible all_vms \
-i /opt/Projet-ISRC/ansible/inventory.ini \
-m wait_for_connection \
-a "timeout=300" \
--private-key /root/.ssh/id_ed25519_isrc

echo ">>> Déploiement Ansible..."

ansible-playbook \
-i /opt/Projet-ISRC/ansible/inventory.ini \
/opt/Projet-ISRC/ansible/playbook.yml \
--private-key /root/.ssh/id_ed25519_isrc \
--timeout 300 \
-v

echo ">>> DONE !"
