# variable declaration so that my secrets arent exposed
variable "proxmox_url" {
  description = "URL of the Proxmox API"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key to inject into VMs"
  type        = string
}
