# variable declaration so that my secrets arent exposed
variable "proxmox_url" {
  description = "URL of the Proxmox API"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token in format user@realm!tokenid=secret"
  type        = string
  sensitive   = true
}
