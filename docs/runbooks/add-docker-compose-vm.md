# Add Docker Compose VM

**Template:** `tmpl-docker-compose` (VM ID 101)  
**Last Updated:** June 2026

---

## Template Specs

| Setting | Value |
|---------|-------|
| Base OS | Ubuntu Server 24.04.4 LTS |
| CPU | 2 cores (x86-64-v2) |
| Memory | 2048 MB (override per-VM as needed) |
| Disk | 40 GB, VirtIO SCSI, discard on |
| Network | VirtIO, bridged via vmbr0 |
| Storage Pool | vm-storage |

### Installed Packages

| Package | Purpose |
|---------|---------|
| qemu-guest-agent | Proxmox integration |
| docker-ce | Container runtime |
| docker-compose-plugin | Docker Compose v2 |
| curl, wget, git | Utilities |
| htop | Process monitor |
| ufw | Firewall |
| openssh-server | Remote access |

---

## Creating a New Docker Compose VM

> VMs are managed via Terraform. Do not clone manually through the Proxmox UI.

### 1. Add a module block to `terraform/main.tf`

```hcl
module "svc_pihole" {
  source         = "./modules/docker-compose"
  vm_id          = 302
  name           = "svc-pihole"
  ip             = "192.168.0.132/24"
  ssh_public_key = var.ssh_public_key
}
```

Override defaults as needed:

```hcl
module "svc_pihole" {
  source         = "./modules/docker-compose"
  vm_id          = 302
  name           = "svc-pihole"
  ip             = "192.168.0.132/24"
  ssh_public_key = var.ssh_public_key
  memory         = 4096  # optional override
  disk_size      = 80    # optional override for data-heavy services
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

### 4. Open Firewall Ports for Your Service

```bash
sudo ufw allow <port>/tcp
sudo ufw reload
```

### 5. Create Your Compose File and Start the Service

```bash
mkdir ~/my-service && cd ~/my-service
nano docker-compose.yml
docker compose up -d
```

### 6. Verify the Service is Running

```bash
docker compose ps
docker compose logs
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
| VM Name | `svc-<service>` | `svc-pihole` |
| Hostname | Same as VM name | `svc-pihole` |
| IP Address | Static, sequential from .131 | 192.168.0.131, .132, .133... |
| VM ID | Sequential from 301 | 301, 302, 303... |
| Terraform module | `svc_<service>` | `svc_pihole` |
