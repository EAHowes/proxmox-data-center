# Postgres Template

> All specs, packages, and configs for a base PostgreSQL node from template.

**Base OS:** Ubuntu Server 24.04 LTS

---

## VM Specifications

| Setting | Value |
|---------|-------|
| CPU | 2 cores (x86-64-v2) |
| Memory | 2048 MB |
| Disk | 21 GB, VirtIO SCSI, discard on |
| Network | VirtIO, bridged via vmbr0 |
| Storage Pool | vm-storage |
| Machine Type | i440fx |
| BIOS | SeaBIOS |
| Cloud-Init | DHCP, SSH key injected, hostname set per-clone |

---

## Pre-installed Packages

| Package | Purpose |
|---------|---------|
| qemu-guest-agent | Proxmox integration |
| postgresql | PostgreSQL 16 database server |
| postgresql-contrib | Additional PostgreSQL utilities and extensions |

---

## System Configuration

**Swap:** Default (not disabled)

**PostgreSQL:** Enabled and starts automatically on boot via systemd. Default cluster created at install. No custom configuration applied — configure per-instance after clone.

**Notes:**
- No application databases or users are pre-created
- `postgres` superuser available via `sudo -u postgres psql`
- Data directory: `/var/lib/postgresql/`
- Config directory: `/etc/postgresql/`
