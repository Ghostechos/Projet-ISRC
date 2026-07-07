variable "proxmox_node" {
  description = "Nom du nœud Proxmox"
  type        = string
  default     = "pve"
}

variable "storage" {
  description = "Storage Proxmox pour les disques VMs"
  type        = string
  default     = "local-lvm"
}

variable "ssh_public_key" {
  description = "Clé SSH publique pour accéder aux VMs"
  type        = string
}

variable "network_bridge" {
  description = "Bridge réseau Proxmox"
  type        = string
  default     = "vmbr1"
}

variable "vmid_wazuh" {
  type = number
}

variable "vmid_graylog" {
  type = number
}

variable "vmid_ia" {
  type = number
}
