terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://192.168.1.115:8006/api2/json"
  pm_api_token_id     = "terraform@pve!terraform-token"
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure     = true
}
