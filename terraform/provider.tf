terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.46.4"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://192.168.1.115:8006/"
  api_token = "terraform@pve!terraform-token=7ec24cef-5c9e-4b3f-a50f-bc9db159fefa"
  insecure  = true
}
