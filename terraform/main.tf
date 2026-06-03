# ============================================================
#  main.tf — 6 VMs projet ISRC LOGISTIA
#  Toutes sous Debian 12 (Bookworm)
#  Serveur : 32 GB RAM
#  node1 : srv-web, srv-db, srv-runner
#  node2 : srv-wazuh, srv-graylog, srv-ia
# ============================================================

# ---------- VM 1 : srv-web — Nginx + App LOGISTIA (VLAN 20) ----------
resource "proxmox_vm_qemu" "srv_web" {
  name        = "srv-web"
  target_node = var.proxmox_node
  clone       = "debian-12-template"
  full_clone  = true
  vmid        = 101

  cores   = 2
  memory  = 1024
  os_type = "cloud-init"

  disk {
    slot    = "scsi0"
    size    = "20G"
    type    = "scsi"
    storage = var.storage
  }

  network {
    model  = "virtio"
    bridge = var.network_bridge
    tag    = 20  # VLAN 20
  }

  ciuser  = "debian"
  sshkeys = var.ssh_public_key
  tags    = "web,nginx,docker,vlan20,logistia"
}

# ---------- VM 2 : srv-db — MariaDB (VLAN 20) ----------
resource "proxmox_vm_qemu" "srv_db" {
  name        = "srv-db"
  target_node = var.proxmox_node
  clone       = "debian-12-template"
  full_clone  = true
  vmid        = 102

  cores   = 2
  memory  = 4096
  os_type = "cloud-init"

  disk {
    slot    = "scsi0"
    size    = "40G"
    type    = "scsi"
    storage = var.storage
  }

  network {
    model  = "virtio"
    bridge = var.network_bridge
    tag    = 20  # VLAN 20
  }

  ciuser  = "debian"
  sshkeys = var.ssh_public_key
  tags    = "db,mariadb,vlan20,logistia"
}

# ---------- VM 3 : srv-runner — GitHub Actions Runner (VLAN 50) ----------
resource "proxmox_vm_qemu" "srv_runner" {
  name        = "srv-runner"
  target_node = var.proxmox_node
  clone       = "debian-12-template"
  full_clone  = true
  vmid        = 103

  cores   = 2
  memory  = 1024
  os_type = "cloud-init"

  disk {
    slot    = "scsi0"
    size    = "20G"
    type    = "scsi"
    storage = var.storage
  }

  network {
    model  = "virtio"
    bridge = var.network_bridge
    tag    = 50  # VLAN 50
  }

  ciuser  = "debian"
  sshkeys = var.ssh_public_key
  tags    = "runner,cicd,vlan50,logistia"
}

# ---------- VM 4 : srv-wazuh — SOC Wazuh Manager (VLAN 30) ----------
resource "proxmox_vm_qemu" "srv_wazuh" {
  name        = "srv-wazuh"
  target_node = var.proxmox_node
  clone       = "debian-12-template"
  full_clone  = true
  vmid        = 104

  cores   = 4
  memory  = 8192
  os_type = "cloud-init"

  disk {
    slot    = "scsi0"
    size    = "50G"
    type    = "scsi"
    storage = var.storage
  }

  network {
    model  = "virtio"
    bridge = var.network_bridge
    tag    = 30  # VLAN 30
  }

  ciuser  = "debian"
  sshkeys = var.ssh_public_key
  tags    = "soc,wazuh,vlan30,logistia"
}

# ---------- VM 5 : srv-graylog — Graylog + Elasticsearch (VLAN 30) ----------
resource "proxmox_vm_qemu" "srv_graylog" {
  name        = "srv-graylog"
  target_node = var.proxmox_node
  clone       = "debian-12-template"
  full_clone  = true
  vmid        = 105

  cores   = 4
  memory  = 8192
  os_type = "cloud-init"

  disk {
    slot    = "scsi0"
    size    = "50G"
    type    = "scsi"
    storage = var.storage
  }

  network {
    model  = "virtio"
    bridge = var.network_bridge
    tag    = 30  # VLAN 30
  }

  ciuser  = "debian"
  sshkeys = var.ssh_public_key
  tags    = "logs,graylog,elasticsearch,vlan30,logistia"
}

# ---------- VM 6 : srv-ia — Isolation Forest (VLAN 40) ----------
resource "proxmox_vm_qemu" "srv_ia" {
  name        = "srv-ia"
  target_node = var.proxmox_node
  clone       = "debian-12-template"
  full_clone  = true
  vmid        = 106

  cores   = 4
  memory  = 8192
  os_type = "cloud-init"

  disk {
    slot    = "scsi0"
    size    = "50G"
    type    = "scsi"
    storage = var.storage
  }

  network {
    model  = "virtio"
    bridge = var.network_bridge
    tag    = 40  # VLAN 40
  }

  ciuser  = "debian"
  sshkeys = var.ssh_public_key
  tags    = "ia,isolation-forest,vlan40,logistia"
}
