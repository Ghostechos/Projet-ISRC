# ============================================================
#  main.tf — 3 VMs projet ISRC LOGISTIA
#  srv-web (103) et srv-db (104) déjà créés manuellement
# ============================================================

resource "proxmox_virtual_environment_vm" "srv_wazuh" {
  node_name = var.proxmox_node
  vm_id     = 105
  name      = "srv-wazuh"
  clone {
    vm_id = 100
    full  = true
  }
  cpu { cores = 4; type = "x86-64-v2-AES" }
  memory { dedicated = 4096 }
  disk { datastore_id = var.storage; size = 100; interface = "scsi0" }
  network_device { bridge = var.network_bridge; vlan_id = 30; model = "virtio" }
  initialization {
    user_account {
      username = "debian"
      keys     = [var.ssh_public_key]
    }
  }
  tags = ["soc", "wazuh", "vlan30", "logistia"]
}

resource "proxmox_virtual_environment_vm" "srv_graylog" {
  node_name = var.proxmox_node
  vm_id     = 106
  name      = "srv-graylog"
  clone {
    vm_id = 100
    full  = true
  }
  cpu { cores = 4; type = "x86-64-v2-AES" }
  memory { dedicated = 4096 }
  disk { datastore_id = var.storage; size = 100; interface = "scsi0" }
  network_device { bridge = var.network_bridge; vlan_id = 30; model = "virtio" }
  initialization {
    user_account {
      username = "debian"
      keys     = [var.ssh_public_key]
    }
  }
  tags = ["logs", "graylog", "elasticsearch", "vlan30", "logistia"]
}

resource "proxmox_virtual_environment_vm" "srv_ia" {
  node_name = var.proxmox_node
  vm_id     = 107
  name      = "srv-ia"
  clone {
    vm_id = 100
    full  = true
  }
  cpu { cores = 4; type = "x86-64-v2-AES" }
  memory { dedicated = 4096 }
  disk { datastore_id = var.storage; size = 100; interface = "scsi0" }
  network_device { bridge = var.network_bridge; vlan_id = 40; model = "virtio" }
  initialization {
    user_account {
      username = "debian"
      keys     = [var.ssh_public_key]
    }
  }
  tags = ["ia", "isolation-forest", "vlan40", "logistia"]
}
