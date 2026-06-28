# All the standard info needed to initialize a VM from template

terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  vm_id     = var.vm_id
  name      = var.name
  node_name = "proxmox-datacenter"

  clone {
    # tmpl-docker-compose
    vm_id = 101
    full  = true
  }

cpu {
  cores = var.cores
  type  = "x86-64-v2"
}

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.storage
    interface    = "scsi0"
    discard      = "on"
    size         = var.disk_size
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    datastore_id = var.cloudinit_storage
    ip_config {
      ipv4 {
        address = var.ip
        gateway = var.gateway
      }
    }
    user_account {
      username = "ubuntu"
      keys     = [var.ssh_public_key]
    }
  }

  operating_system {
    # Linux 2.6+ kernel
    type = "l26"
  }
}

