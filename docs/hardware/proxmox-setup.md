# Dell PowerEdge R510 — Proxmox VE Setup Documentation PUBLIC FACING

**Date:** June 18-19, 2026  
**Author:** Ethan  
**Purpose:** Homelab server running Proxmox VE for virtualization and homelabbing

---

## Table of Contents

1. [Hardware Specifications](#hardware-specifications)
2. [System Metrics](#system-metrics)
3. [Network Information](#network-information)
4. [Storage Layout](#storage-layout)
5. [RAID Configuration](#raid-configuration)
6. [Software Stack](#software-stack)
7. [Setup Process](#setup-process)
8. [Access Methods](#access-methods)
9. [Known Issues](#known-issues)
10. [Useful Commands](#useful-commands)
11. [Next Steps](#next-steps)

---

## Hardware Specifications

| Component | Details |
|-----------|---------|
| Model | Dell PowerEdge R510 2U Rack Server |
| CPUs | Dual Intel Xeon E5540 @ 2.53GHz (Quad-core, 8 threads each, 16 threads total) |
| CPU Bus Speed | 5.86 GT/s |
| L2/L3 Cache | 1MB / 8MB per CPU |
| RAM | 64GB DDR3 ECC (8x 8GB DIMMs) @ 800MHz, 1.5V |
| RAM Slots | 8 populated (A0, A1, A2, A3, A4, A5, A6, A7) |
| Drive Bays | 12x 3.5" SATA bays |
| Drives | 2x 500GB 3.5" SATA + 4x 1TB 3.5" SATA |
| RAID Card | Dell PERC H700 (LSI Corporation) |
| Power Supplies | Dual 750W redundant PSUs |
| Embedded NICs | Dual embedded Gigabit NICs (Gb1, Gb2) |
| Additional NICs | Intel 10GB NIC, Chelsio 10GB NIC (not installed during setup) |
| Remote Management | iDRAC6 Enterprise |
| Form Factor | 2U Rack Mount |
| Rails | Rack mount rails included |
| BIOS | Phoenix ROM BIOS PLUS Version 1.10 |
| Service Tag | [redacted — stored privately] |
| Express Service Code | [redacted — stored privately] |

---

## System Metrics

| Metric | Value |
|--------|-------|
| CPU Usage (at setup) | 0.2% of 16 cores |
| Memory Usage (at setup) | 3.3% (~2.1GB of 64GB) |
| OS Disk Usage | 5.7% of 465GB |
| VM Storage Usage | 0.0% of 2.7TB |
| System Uptime (first boot) | 00:07:43 after install |
| Proxmox Version | 9.2.x |
| Debian Version | Trixie (13) |
| iDRAC Firmware | 2.9x |
| iDRAC Hardware Version | 0.01 |
| PERC H700 Firmware | 2.8x |

---

## Network Information

### Physical Network
| Interface | MAC Address | IP Address | Speed |
|-----------|-------------|------------|-------|
| iDRAC (Dedicated) | xx:xx:xx:xx:xx:x3 | 192.168.0.105 | 100Mb/s Full Duplex |
| NIC1 (Gb1) / nic0 | xx:xx:xx:xx:xx:x1 | 192.168.0.103 | 1Gb/s |
| NIC2 (Gb2) / nic1 | xx:xx:xx:xx:xx:x2 | — | — |

### Tailscale Network
| Device | Tailscale IP |
|--------|-------------|
| proxmox-datacenter | 100.xxx.xxx.xxx |
| ethan-fedora | 100.xxx.xxx.xxx |
| k3s-raspi4b-1 | 100.xxx.xxx.xxx |
| omen-server | 100.xxx.xxx.xxx |

### Network Configuration (`/etc/network/interfaces`)
```
auto lo
iface lo inet loopback

iface nic0 inet manual

auto vmbr0
iface vmbr0 inet static
        address 192.168.0.103/24
        gateway 192.168.0.1
        bridge-ports nic0
        bridge-stp off
        bridge-fd 0

iface nic1 inet manual

source /etc/network/interfaces.d/*
```

### Router
| Setting | Value |
|---------|-------|
| Model | TP-Link AX1300 Gigabit Wi-Fi 6 Router |
| Gateway IP | 192.168.0.1 |
| DNS | 192.168.0.1 |
| AP Isolation | Disabled |

---

## Storage Layout

### Physical Drives
| Device | Type | Raw Size | RAID Role |
|--------|------|----------|-----------|
| /dev/sda | RAID 1 Virtual Disk (2x500GB) | 465.25GB | OS Drive |
| /dev/sdb | RAID 5 Virtual Disk (4x1TB) | 2.73TB | VM Storage |

### Logical Volumes on /dev/sda
| Volume | Size | Mount | Purpose |
|--------|------|-------|---------|
| pve-swap | 8GB | [SWAP] | Swap space |
| pve-root | 96GB | / | Proxmox OS root |
| pve-data | 337.4GB | — | LVM-Thin pool for local VM storage |

### Proxmox Storage Pools
| ID | Type | Size | Content | Purpose |
|----|------|------|---------|---------|
| local | Directory | — | Backup, Import, ISO | ISOs and backups (`/var/lib/vz`) |
| local-lvm | LVM-Thin | 337GB | Disk image, Container | OS drive overflow storage |
| vm-storage | LVM-Thin | 2.7TB | Disk image, Container | Primary VM storage |

---

## RAID Configuration

### PERC H700 Virtual Disks

**Virtual Disk 0 — OS Drive**
| Setting | Value |
|---------|-------|
| RAID Level | RAID 1 (Mirror) |
| Physical Drives | 2x 500GB |
| Usable Capacity | 465.25GB |
| State | Optimal |
| Operation | None |
| Disk Group | 0 |

**Virtual Disk 1 — VM Storage**
| Setting | Value |
|---------|-------|
| RAID Level | RAID 5 |
| Physical Drives | 4x 1TB |
| Usable Capacity | ~2.7TB |
| Disk Group | 1 |

---

## Setup Process

### Step 1 — Preparation
- Downloaded Proxmox VE 9.2-1 ISO on Fedora machine
- Flashed ISO to 64GB USB drive:
```bash
sudo dd if=~/Downloads/proxmox-ve_9.2-1.iso of=/dev/sda bs=4M status=progress oflag=sync
```

### Step 2 — BIOS Configuration
Accessed system BIOS via racadm one-time boot command:
```bash
racadm config -g cfgServerInfo -o cfgServerFirstBootDevice BIOS
```

BIOS changes made:
- USB Flash Drive Emulation Type → Hard Disk
- Hard-Disk Drive Sequence → moved USB Flash Disk to position 1

### Step 3 — RAID Configuration
Accessed PERC H700 BIOS via Ctrl+R at POST.

- Created Virtual Disk 0: RAID 1 on 2x500GB drives (OS)
- Virtual Disk 1: RAID 5 on 4x1TB drives (VM storage) — was already configured

### Step 4 — Proxmox Installation
Booted from USB drive and ran graphical installer.

**Installer settings:**
| Setting | Value |
|---------|-------|
| Target Disk | Virtual Disk 0 (465GB RAID 1) |
| Country | United States |
| Timezone | America/New_York |
| Keyboard | U.S. English |
| Hostname | proxmox-datacenter.local |
| IP Address | 192.168.0.103/24 |
| Gateway | 192.168.0.1 |
| DNS | 192.168.0.1 |

### Step 5 — Post-Install Script
Ran the community post-install script:
```bash
bash -c "$(wget -qLO - https://github.com/community-scripts/ProxmoxVE/raw/main/misc/post-pve-install.sh)"
```

Script actions:
- Disabled pve-enterprise repository
- Disabled ceph-enterprise repository
- Added pve-no-subscription repository
- Added pvetest repository (disabled)
- Disabled subscription nag popup
- Disabled High Availability services
- Disabled Corosync
- Updated all packages
- Rebooted

### Step 6 — VM Storage Setup
Wiped existing partitions on /dev/sdb:
```bash
wipefs -a /dev/sdb
dd if=/dev/zero of=/dev/sdb bs=1M count=10
```

Created LVM volume group and thin pool:
```bash
pvcreate /dev/sdb
vgcreate vm-storage /dev/sdb
lvcreate -l 100%FREE -T vm-storage/data
```

Added in Proxmox web UI: Datacenter → Storage → Add → LVM-Thin
- ID: vm-storage
- Volume group: vm-storage
- Thin pool: data
- Content: Disk image, Container

### Step 7 — Tailscale Installation
Enabled IP forwarding:
```bash
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf
sysctl -p
```

Installed Tailscale:
```bash
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up
```

Subnet routing (`192.168.0.0/24`) is handled by the Raspberry Pi (`k3s-raspi4b-1`) as an always-on subnet router. See [ADR-002](../decisions/ADR-002-subnet-routing-move-to-raspi.md).

On Fedora client:
```bash
tailscale up --accept-routes
```

### Step 8 — SSH Configuration
Copied SSH key for passwordless login:
```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub root@192.168.0.103
```

Added SSH alias on Fedora (`~/.ssh/config`):
```
Host proxmox
    HostName proxmox-datacenter
    User root
```

---

## Access Methods

| Method | Address | Notes |
|--------|---------|-------|
| Proxmox Web UI (local) | https://192.168.0.103:8006 | Local network only |
| Proxmox Web UI (anywhere) | https://proxmox-datacenter:8006 | Via Tailscale MagicDNS |
| SSH (local) | `ssh root@192.168.0.103` | Passwordless with ed25519 key |
| SSH (alias) | `ssh proxmox` | Via ~/.ssh/config alias |
| SSH (Tailscale) | `ssh root@proxmox-datacenter` | Via Tailscale MagicDNS |
| iDRAC | https://192.168.0.105 | Local network only |
| iDRAC SSH | `ssh root@192.168.0.105` | Limited racadm shell |

---

## Known Issues

| Issue | Status | Notes |
|-------|--------|-------|
| iDRAC6 virtual console non-functional | Open | Java compatibility issue |
| iDRAC firmware not latest | Open | -- |

---

## Useful Commands

### Proxmox Host
```bash
# Check disk layout
lsblk

# Check network config
cat /etc/network/interfaces

# Check storage volumes
pvs    # physical volumes
vgs    # volume groups
lvs    # logical volumes

# Edit network config
TERM=xterm nano /etc/network/interfaces

# Restart networking
systemctl restart networking

# Graceful shutdown
shutdown now

# Check Tailscale status
tailscale status

# Check Tailscale IP
tailscale ip

# Check system info via iDRAC SSH
racadm getsysinfo

# Check RAID status via iDRAC SSH
racadm getniccfg

# One-time boot to BIOS
racadm config -g cfgServerInfo -o cfgServerFirstBootDevice BIOS

# Ping from iDRAC
racadm ping <ip>
```

### Fedora Client
```bash
# SSH into Proxmox
ssh proxmox

# Scan network for devices
nmap -sn 192.168.0.0/24

# Scan for specific port
nmap -p 8006 192.168.0.0/24

# Tailscale normal mode (at home)
tailscale up

# Tailscale with subnet routing (remote access)
tailscale up --accept-routes

# Disable Tailscale
tailscale down

# Check routing table
ip route
ip route get 192.168.0.105
```

---

> **Security note:** Service tag, express service code, MAC addresses, Tailscale IPs, and exact firmware versions have been redacted. Real values are maintained privately.
