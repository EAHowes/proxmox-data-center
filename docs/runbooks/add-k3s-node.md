# Add k3s Node PUBLIC FACING

**Template:** `tmpl-k3s-node` (VM ID 100)
**Last Updated:** June 2026

---

## Template Specs

| Setting | Value |
|---------|-------|
| Base OS | Ubuntu Server 24.04.4 LTS |
| CPU | 2 cores (host type) |
| Memory | 4096 MB |
| Disk | 32 GB, VirtIO Block, Write Back cache |
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
| open-iscsi | iSCSI support for storage backends |
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

### 1. Clone the Template

1. Right-click `tmpl-k3s-node` in the Proxmox sidebar → **Clone**
2. Set VM ID
3. Set Name
4. Mode: **Linked Clone**
5. Storage: `vm-storage`
6. Click **Clone**

### 2. Update Cloud-Init Hostname

To make the hostname match the node name:

1. Select the new VM → **Cloud-Init** tab
2. Update the hostname field
3. Click **Regenerate Image**

### 3. Start the VM

Start the VM and wait ~30 seconds for Cloud-Init. The IP address will appear in the **Summary** tab once the VM is up.

### 4. SSH In

```bash
ssh yart@<vm-ip>
```

No password required the SSH key is injected by Cloud-Init.

### 5. Join the k3s Cluster

Run on the worker node:

```bash
curl -sfL https://get.k3s.io | K3S_URL=https://<K3S_SERVER_IP>:6443 \
  K3S_TOKEN=<JOIN_TOKEN> sh -s - agent
```

### 6. Verify the Node Joined

From a machine with kubectl access:

```bash
kubectl get nodes
```

The new node should appear with status `Ready` within 30–60 seconds.

---

## Naming Convention

| Item | Convention | Example |
|------|-----------|---------|
| VM Name | `k3s-worker-NN` | `k3s-worker-01` |
| Hostname | Same as VM name | `k3s-worker-01` |
| VM ID | Sequential from 101 | 101, 102, 103... |
