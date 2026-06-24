# k3s Node Template

> All specs, packages, and configs for a base k3s node from template.
**Base OS:** Ubuntu Server 24.04.4 LTS

---

## VM Specifications

| Setting | Value |
|---------|-------|
| CPU | 2 cores (host type) |
| Memory | 4096 MB |
| Disk | 32 GB, VirtIO Block, Write Back cache |
| Network | VirtIO, bridged via vmbr0 |
| Storage Pool | vm-storage |
| Machine Type | q35 |
| BIOS | SeaBIOS |
| Cloud-Init | DHCP, SSH key injected, hostname set per-clone |

---

## Pre-installed Packages

| Package | Purpose |
|---------|---------|
| qemu-guest-agent | Proxmox integration |
| curl | HTTP utility |
| wget | HTTP utility |
| git | Version control |
| vim | Text editor |
| neovim | Text editor |
| nano | Text editor |
| htop | Interactive process monitor |
| tmux | Terminal multiplexer |
| net-tools | Network debugging (ifconfig, netstat) |
| iproute2 | Network debugging (ip, ss) |
| nfs-common | NFS client support for persistent storage |
| open-iscsi | iSCSI support for storage backends like Longhorn |
| cloud-init | First-boot configuration |
| cloud-initramfs-growroot | Auto-expands root partition to fill disk on first boot |

---

## System Configuration

**Swap:** Disabled permanently via `/etc/fstab`

**Kernel modules** (`/etc/modules-load.d/k3s.conf`):
```
overlay
br_netfilter
```

**Kernel parameters** (`/etc/sysctl.d/k3s.conf`):
```
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
```
