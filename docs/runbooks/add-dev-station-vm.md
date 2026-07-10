# Add Dev Station VM

**Template:** `tmpl-dev-station` (VM ID 103)  
**Last Updated:** June 2026

---

## Template Specs

| Setting | Value |
|---------|-------|
| Base OS | Ubuntu Server 24.04 LTS |
| CPU | 2 cores (x86-64-v2) |
| Memory | 4096 MB (override per-VM as needed) |
| Disk | 34 GB, VirtIO SCSI, Write Back cache, discard on |
| Network | VirtIO, bridged via vmbr0 |
| Storage Pool | vm-storage |

### Installed Packages

| Package | Purpose |
|---------|---------|
| qemu-guest-agent | Proxmox integration |
| git | Version control |
| curl, wget | HTTP |
| build-essential | C/C++ compiler toolchain (gcc, g++, make) |
| htop | Process monitor |
| tree | tree viewer |
| tmux | Terminal multiplexer |
| neovim | Text editor |
| python3 + pip + venv | Python 3 environment |
| nodejs + npm | Node.js |
| rustup | Rust manager |
| golang | Go runtime |
| openjdk-21-jdk | Java 21 JDK |
| docker + docker-compose | Containerization |

---

## Overridable Variables

These variables have defaults set in the module but can be overridden per-VM in `terraform/main.tf`.

| Variable | Default | Required | Description |
|----------|---------|----------|-------------|
| `vm_id` | — | Y | Unique VM ID in Proxmox |
| `name` | — | Y | VM name |
| `ip` | — | Y | Static IP with CIDR, e.g. `192.168.0.151/24` |
| `ssh_public_key` | — | Y | SSH public key injected via Cloud-Init |
| `cores` | `2` | N | Number of CPU cores |
| `memory` | `4096` | N | RAM in MB |
| `disk_size` | `34` | N | Disk size in GB |
| `storage` | `vm-storage` | N | Proxmox storage pool for VM disk |
| `cloudinit_storage` | `local-lvm` | N | Proxmox storage pool for Cloud-Init seed image |
| `gateway` | `192.168.0.1` | N | Network gateway |

---

## Creating a New Dev Station VM

### 1. Add a module block to `terraform/main.tf`

```hcl
module "dev_station_01" {
  source         = "./modules/dev-station"
  vm_id          = 501
  name           = "dev-station-01"
  ip             = "192.168.0.151/24"
  ssh_public_key = var.ssh_public_key
  memory         = 8192  # optional override
  disk_size      = 60    # optional override
}
```

### 2. Plan and apply

```bash
cd terraform
terraform plan
terraform apply
```

### 3. SSH

```bash
ssh yart@<vm-ip>
```

SSH key is injected by Cloud-Init.

---

## Removing a VM

Remove or comment out the module block in `terraform/main.tf`, then:

```bash
cd terraform
terraform plan
terraform apply
```

Terraform will stop and destroy the VM cleanly.

---

## Naming Convention

| Item | Convention | Example |
|------|-----------|---------|
| VM Name | `dev-station-NN` | `dev-station-01` |
| Hostname | Same as VM name | `dev-station-01` |
| IP Address | Static, sequential from .151 | 192.168.0.151, .152, .153... |
| VM ID | Sequential from 501 | 501, 502, 503... |
| Terraform module | `dev_station_NN` | `dev_station_01` |
