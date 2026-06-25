# Add Docker Compose VM PUBLIC FACING

**Template:** `tmpl-docker-compose` (VM ID 101)
**Last Updated:** June 2026

---

## Template Specs

| Setting | Value |
|---------|-------|
| Base OS | Ubuntu Server 24.04.4 LTS |
| CPU | 2 cores (host type) |
| Memory | 4096 MB |
| Disk | 40 GB, SCSI, Write Back cache |
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

### 1. Clone the Template

1. Right-click `tmpl-docker-compose` in the Proxmox sidebar → **Clone**
2. Set VM ID
3. Set Name
4. Mode: **Full Clone**
5. Storage: `vm-storage`
6. Click **Clone**

### 2. Set Static IP via Cloud-Init

1. Select the new VM → **Cloud-Init** tab
2. Set **IP Config (net0)** to `ip=192.168.0.XXX/24,gw=192.168.0.1`
3. Update the hostname field to match the service name
4. Click **Regenerate Image**

### 3. Start the VM

Start the VM and wait ~30 seconds for Cloud-Init. The IP address will appear in the **Summary** tab once the VM is up.

### 4. SSH In

```bash
ssh yart@<vm-ip>
```

No password required — the SSH key is injected by Cloud-Init.

### 5. Open Firewall Ports for Your Service

```bash
sudo ufw allow <port>/tcp
sudo ufw reload
```

### 6. Create Your Compose File and Start the Service

```bash
mkdir ~/my-service && cd ~/my-service
nano docker-compose.yml
docker compose up -d
```

### 7. Verify the Service is Running

```bash
docker compose ps
docker compose logs
```

---

## Naming Convention

| Item | Convention | Example |
|------|-----------|---------|
| VM Name | `svc-<service>` | `svc-pihole` |
| Hostname | Same as VM name | `svc-pihole` |
| IP Address | Static, sequential from .110 | 192.168.0.110, .111, .112... |
| VM ID | Sequential from 200 | 200, 201, 202... |

---

## Notes

- Use **Full Clone** (not Linked) so each VM is fully independent
- UFW only allows SSH by default — open service ports manually after cloning
- Memory and CPU can be adjusted per-clone depending on service requirements
- For services with large data volumes, consider adding a second disk rather than expanding the OS disk
