# Add Postgres VM

**Template:** `tmpl-postgres` (VM ID 102)  
**Last Updated:** June 2026

---

## Template Specs

| Setting | Value |
|---------|-------|
| Base OS | Ubuntu Server 24.04 LTS |
| CPU | 2 cores (x86-64-v2) |
| Memory | 2048 MB (override per-VM as needed) |
| Disk | 21 GB, VirtIO SCSI, discard on |
| Network | VirtIO, bridged via vmbr0 |
| Storage Pool | vm-storage |

### Installed Packages

| Package | Purpose |
|---------|---------|
| qemu-guest-agent | Proxmox integration |
| postgresql | PostgreSQL 16 database server |
| postgresql-contrib | Additional PostgreSQL utilities and extensions |

### Notes

- No application databases or users are pre-created
- `postgres` superuser available via `sudo -u postgres psql`
- Data directory: `/var/lib/postgresql/`
- Config directory: `/etc/postgresql/`

---

## Overridable Variables

These variables have defaults set in the module but can be overridden per-VM in `terraform/main.tf`.

| Variable | Default | Required | Description |
|----------|---------|----------|-------------|
| `vm_id` | — | Y | Unique VM ID in Proxmox |
| `name` | — | Y | VM name |
| `ip` | — | Y | Static IP with CIDR, e.g. `192.168.0.141/24` |
| `ssh_public_key` | — | Y | SSH public key injected via Cloud-Init |
| `cores` | `2` | N | Number of CPU cores |
| `memory` | `2048` | N | RAM in MB |
| `disk_size` | `21` | N | Disk size in GB |
| `storage` | `vm-storage` | N | Proxmox storage pool for VM disk |
| `cloudinit_storage` | `local-lvm` | N | Proxmox storage pool for Cloud-Init seed image |
| `gateway` | `192.168.0.1` | N | Network gateway |

---

## Creating a New Postgres VM

> VMs are managed via Terraform. Do not clone manually through the Proxmox UI.

### 1. Add a module block to `terraform/main.tf`

```hcl
module "postgres_dev_01" {
  source         = "./modules/postgres"
  vm_id          = 401
  name           = "postgres-dev-01"
  ip             = "192.168.0.141/24"
  ssh_public_key = var.ssh_public_key
}
```

Override defaults as needed:

```hcl
module "postgres_dev_01" {
  source         = "./modules/postgres"
  vm_id          = 401
  name           = "postgres-dev-01"
  ip             = "192.168.0.141/24"
  ssh_public_key = var.ssh_public_key
  memory         = 4096  # optional override for larger workloads
  disk_size      = 50    # optional override for large databases
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

No password required. The SSH key is injected by Cloud-Init.

### 4. Create a Database and User

```bash
sudo -u postgres psql
```

```sql
CREATE DATABASE mydb;
CREATE USER myuser WITH PASSWORD 'mypassword';
GRANT ALL PRIVILEGES ON DATABASE mydb TO myuser;
\q
```

### 5. Allow Remote Connections (optional)

By default PostgreSQL only listens on localhost. To allow remote connections:

```bash
sudo nano /etc/postgresql/*/main/postgresql.conf
```

Change:
```
listen_addresses = 'localhost'
```
To:
```
listen_addresses = '*'
```

Then add a rule to `pg_hba.conf`:

```bash
sudo nano /etc/postgresql/*/main/pg_hba.conf
```

Add at the bottom:
```
host    all             all             192.168.0.0/24          scram-sha-256
```

Restart PostgreSQL:

```bash
sudo systemctl restart postgresql
```

### 6. Verify PostgreSQL is Running

```bash
sudo systemctl status postgresql
sudo -u postgres psql -c "\l"
```

---

## Removing a VM

Remove or comment out the module block in `terraform/main.tf`, then:

```bash
cd terraform
terraform plan
terraform apply
```

Terraform will stop and destroy the VM.

---

## Naming Convention

| Item | Convention | Example |
|------|-----------|---------|
| VM Name | `postgres-<env>-NN` | `postgres-dev-01` |
| Hostname | Same as VM name | `postgres-dev-01` |
| IP Address | Static, sequential from .141 | 192.168.0.141, .142, .143... |
| VM ID | Sequential from 401 | 401, 402, 403... |
| Terraform module | `postgres_<env>_NN` | `postgres_dev_01` |
