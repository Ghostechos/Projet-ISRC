variable "proxmox_token_secret" {
  description = "Token secret du compte terraform@pve — ne jamais commit ce fichier"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Nom du nœud Proxmox"
  type        = string
  default     = "pve-logistia"
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
  default     = "vmbr0"
}
