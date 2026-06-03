# ============================================================
#  terraform.tfvars — Valeurs secrètes
#  IMPORTANT : copier ce fichier en terraform.tfvars
#  et NE JAMAIS commit terraform.tfvars sur GitHub !
# ============================================================

proxmox_token_secret = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBkxCvdAiKNfE3wxDeqFBgEGYgp60YP8eZtYItMA58yR piyas-isrc-logistia"

ssh_public_key = "2f52ba0e-dd33-4bb6-ad2d-f99e5acc85fb"

# Optionnel — laisser par défaut si pas changé
proxmox_node   = "pve-logistia"
storage        = "local-lvm"
network_bridge = "vmbr0"
