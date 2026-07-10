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
| curl | HTTP |
| git | Version control |
| htop |Process monitor |
| ufw | Firewall |
| openssh-server | Remote access |
