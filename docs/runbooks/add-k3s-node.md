# Add k3s Node VM

**Template:** `tmpl-k3s-worker` (VM ID 100)  
**Last Updated:** June 2026

---

## Template Specs

| Setting | Value |
|---------|-------|
| Base OS | Ubuntu Server 24.04.4 LTS |
| CPU | 2 cores (x86-64-v2) |
| Memory | 2048 MB (override per-node as needed) |
| Disk | 20 GB, VirtIO SCSI, discard on |
| Network | VirtIO, bridged via vmbr0 |
| Storage Pool | vm-storage |

### Installed Packages

| Package | Purpose |
|---------|---------|
| qemu-guest-agent | Proxmox integration |
| curl, wget, git | Utilities |
| vim, neovim, nano | Text editors |
| htop, tmux | Monitoring and terminal multiplexer |
| net-tools, iproute2 | Network debugging |
| nfs-common | NFS client for persistent storage |
| cloud-init | First-boot configuration |

### Kernel Configuration

Modules loaded at boot (`/etc/modules-load.d/k3s.conf`):
```
overlay
br_netfilter
```

Kernel parameters (`/etc/sysctl.d/k3s.conf`):
```
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
```

Swap is disabled permanently via `/etc/fstab` to allow node to join k3s cluster.

---

## Creating a New Worker Node

> VMs are managed via Terraform.

### 1. Add a module block to `terraform/main.tf`

```hcl
module "k3s_worker_02" {
  source         = "./modules/k3s-node"
  vm_id          = 202
  name           = "k3s-worker-02"
  ip             = "192.168.0.122/24"
  ssh_public_key = var.ssh_public_key
}
```

Override defaults as needed:

```hcl
module "k3s_worker_02" {
  source         = "./modules/k3s-node"
  vm_id          = 202
  name           = "k3s-worker-02"
  ip             = "192.168.0.122/24"
  ssh_public_key = var.ssh_public_key
  memory         = 4096  # optional override
  cores          = 4     # optional override
}
```

### 2. Plan and apply

```bash
cd terraform
terraform plan
terraform apply
```

### 3. SSH In

```bash
ssh yart@<vm-ip>
```

SSH key is injected by Cloud-Init.

### 4. Join the k3s Cluster

Run on the worker node:

```bash
curl -sfL https://get.k3s.io | K3S_URL=https://<K3S_SERVER_IP>:6443 \
  K3S_TOKEN=<JOIN_TOKEN> sh -s - agent
```

### 5. Verify the Node Joined

From a machine with kubectl access:

```bash
kubectl get nodes
```

---

## Removing a Worker Node

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
| VM Name | `k3s-worker-NN` | `k3s-worker-01` |
| Hostname | Same as VM name | `k3s-worker-01` |
| IP Address | Static, sequential from .121 | 192.168.0.121, .122, .123... |
| VM ID | Sequential from 201 | 201, 202, 203... |
| Terraform module | `k3s_worker_NN` | `k3s_worker_01` |
