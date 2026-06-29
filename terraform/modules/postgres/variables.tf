# declare all the variables that this module accepts

variable "vm_id" {
  description = "Unique VM ID in Proxmox"
  type        = number
}

variable "name" {
  description = "VM name, e.g. postgres-dev-01"
  type        = string
}

variable "ip" {
  description = "Static IP with CIDR, e.g. 192.168.0.121/24"
  type        = string
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "memory" {
  description = "RAM in MB"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 21
}

variable "storage" {
  description = "Proxmox storage pool to use"
  type        = string
  default     = "vm-storage"
}

variable "gateway" {
  description = "Network gateway"
  type        = string
  default     = "192.168.0.1"
}

variable "ssh_public_key" {
  description = "SSH public key for Cloud-Init"
  type        = string
}

variable "cloudinit_storage" {
  description = "Storage pool for Cloud-Init seed image"
  type        = string
  default     = "local-lvm"
}

