# Docker Compose VM Template

> All specs, packages, and configs for a base Docker Compose VM from template.

**Base OS:** Ubuntu Server 24.04.4 LTS

---

## VM Specifications

| Setting | Value |
|---------|-------|
| CPU | 2 cores (host type) |
| Memory | 4096 MB |
| Disk | 40 GB, SCSI, Write Back cache, Discard on |
| Network | VirtIO, bridged via vmbr0 |
| Storage Pool | vm-storage |
| Machine Type | q35 |
| BIOS | SeaBIOS |
| SCSI Controller | VirtIO SCSI Single |
| Cloud-Init | DHCP default, SSH key injected, hostname set per-clone |

---

## Pre-installed Packages

| Package | Purpose |
|---------|---------|
| qemu-guest-agent | Proxmox integration |
| docker-ce | Container runtime |
| docker-compose-plugin | Docker Compose v2 |
| curl | HTTP utility |
| wget | HTTP utility |
| git | Version control |
| htop | Interactive process monitor |
| ufw | Firewall management |
| openssh-server | Remote access |

---

## System Configuration

**Docker:** Installed via official `get.docker.com` script, enabled at boot

**UFW:** Active — OpenSSH allowed by default.

**User:** `yart` is in the `docker` group, thus no sudo required to run Docker commands
