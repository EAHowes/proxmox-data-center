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
    vm_id = 100  # tmpl-k3s-worker
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
    interface    = "virtio0"
    discard      = "on"
    size         = 32
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    datastore_id = var.cloudinit_storage
    dns {
      servers = ["192.168.0.1"]
    }
    ip_config {
      ipv4 {
        address = var.ip
        gateway = var.gateway
      }
    }
    user_account {
      username = "yart"
      keys     = [var.ssh_public_key]
    }
  }

  operating_system {
    type = "l26"  # Linux 2.6+ kernel
  }
}
