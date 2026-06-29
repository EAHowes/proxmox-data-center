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
| curl, wget | HTTP utilities |
| unzip, zip | Archive utilities |
| build-essential | C/C++ compiler toolchain (gcc, g++, make) |
| ripgrep | Fast grep alternative |
| fzf | Fuzzy finder |
| fd-find | Fast find alternative |
| htop | Interactive process monitor |
| tree | Directory tree viewer |
| jq | JSON processor |
| tmux | Terminal multiplexer |
| neovim | Text editor (v0.9.5) |
| python3 + pip + venv | Python 3 runtime and package management |
| nodejs + npm | Node.js LTS via nvm |
| rustup | Rust toolchain manager |
| golang | Go runtime |
| openjdk-21-jdk | Java 21 JDK |
| docker + docker-compose | Container runtime and compose plugin |

### Notes

- No dotfiles or editor config pre-applied — configure per-instance after clone
- `yart` user is in the `docker` group — no `sudo` required for docker commands
- nvm and rustup are sourced via `~/.bashrc`

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
}
```

Override defaults as needed:

```hcl
module "dev_station_01" {
  source         = "./modules/dev-station"
  vm_id          = 501
  name           = "dev-station-01"
  ip             = "192.168.0.151/24"
  ssh_public_key = var.ssh_public_key
  memory         = 8192  # optional override for heavier workloads
  disk_size      = 60    # optional override for larger projects
}
```

### 2. Plan and apply

```bash
cd terraform
terraform plan
terraform apply
```

Terraform will clone the template, set the static IP via Cloud-Init, and start the VM. Existing VMs are not affected.

### 3. SSH In

```bash
ssh yart@<vm-ip>
```

No password required — the SSH key is injected by Cloud-Init.

### 4. Set Up Your Environment

Clone dotfiles or configure environment as needed:

```bash
# Example — clone dotfiles repo
git clone https://github.com/<you>/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./install.sh
```

### 5. Verify Languages and Tools

```bash
node --version
python3 --version
go version
rustc --version
java -version
docker --version
nvim --version
```

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
