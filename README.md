# Proxmox Datacenter

Personal homelab running on a Dell PowerEdge R510 with Proxmox VE. This repo contains documentation for infrastructure, configuration, and automation.

> For security, some information has been redacted or omitted from this repo and is maintained privately.
---

## Hardware

| Component | Details |
|-----------|---------|
| Host | Dell PowerEdge R510 2U |
| CPU | Dual Intel Xeon E5540 @ 2.53GHz (16 threads total) |
| RAM | 64GB DDR3 ECC |
| OS Storage | 465GB (2x 500GB RAID 1) |
| VM Storage | 2.7TB (4x 1TB RAID 5) |
| Hypervisor | Proxmox VE 9.2.3 on Debian Trixie |
| Remote Mgmt | iDRAC6 Enterprise |

---

## Quick Access

| Method | Address | Notes |
|--------|---------|-------|
| Proxmox Web UI (local) | https://192.168.0.103:8006 | Local network only |
| Proxmox Web UI (anywhere) | https://proxmox-datacenter:8006 | Via Tailscale MagicDNS |
| SSH (local) | `ssh root@192.168.0.103` | Passwordless with ed25519 key |
| SSH (alias) | `ssh proxmox-datacenter` | Via ~/.ssh/config alias |
| SSH (Tailscale) | `ssh root@proxmox-datacenter` | Via Tailscale MagicDNS |
| iDRAC | https://192.168.0.105 | Remote access allowed via Raspi Subnet Router |
| iDRAC SSH | `ssh root@192.168.0.105` | Limited racadm shell |

---

## Spin Up a VM

> Full runbooks: [docs/runbooks/](docs/runbooks/)

**Quick path (Terraform):**
1. Add a module block to `terraform/main.tf` for the appropriate template type
2. `cd terraform && terraform plan && terraform apply`

Cloud-Init handles hostname, SSH key, and network on first boot. SSH in with `ssh yart@<vm-ip>`, no password required.

**Example:**

```hcl
module "svc_pihole" {
  source         = "./modules/docker-compose"
  vm_id          = 302
  name           = "svc-pihole"
  ip             = "192.168.0.132/24"
  ssh_public_key = var.ssh_public_key
}
```

**Available templates / modules:**

| Template | Module | Purpose |
|----------|--------|---------|
| `tmpl-docker-compose` | `./modules/docker-compose` | App/API service node |
| `tmpl-k3s-node` | `./modules/k3s-node` | k3s cluster worker or control plane |
| `tmpl-postgres` | `./modules/postgres` | PostgreSQL 16 database instance |
| `tmpl-dev-station` | `./modules/dev-station` | Full development environment |

---

## Network Map

> Full detail: [docs/network/topology.md](docs/network/topology.md) · [docs/network/ip-allocation.md](docs/network/ip-allocation.md)

```
Internet
    │
    ▼
TP-Link AX1300 (192.168.0.1)
    │
    ├── proxmox-datacenter  192.168.0.103   Proxmox host / vmbr0 bridge
    │       └── VMs on vmbr0 bridge (192.168.0.0/24)
    │
    └── iDRAC6              192.168.0.105   Out-of-band management

Tailscale Overlay (100.x.x.x)
    ├── proxmox-datacenter  100.xxx.xxx.xxx
    ├── ethan-fedora        100.xxx.xxx.xxx
    ├── k3s-raspi4b-1       100.xxx.xxx.xxx
    └── omen-server         100.xxx.xxx.xxx
```

---

## Runbooks

| Runbook | Description |
|---------|-------------|
| [Add Docker Compose VM](docs/runbooks/add-docker-compose-vm.md) | App/API service node from the docker-compose template |
| [Add k3s Node](docs/runbooks/add-k3s-node.md) | Spin up and join a new k3s worker |
| [Add Postgres VM](docs/runbooks/add-postgres-vm.md) | PostgreSQL 16 database instance from the postgres template |
| [Add Dev Station VM](docs/runbooks/add-dev-station-vm.md) | Full development environment from the dev-station template |
| [Access iDRAC During Reboot](docs/runbooks/idrac-access.md) | How to reach iDRAC when Proxmox is down |

---

## Documentation

| Doc | Description |
|-----|-------------|
| [Hardware & Setup](docs/hardware/proxmox-setup.md) | Full R510 setup log, BIOS config, RAID, install steps |
| [Network Topology](docs/network/topology.md) | Network diagram, interfaces, bridge config |
| [IP Allocation](docs/network/ip-allocation.md) | Static IP assignments for all devices and VMs |
| [Storage Layout](docs/hardware/proxmox-setup.md#storage-layout) | RAID config, LVM volumes, Proxmox storage pools |
| [VM Templates](docs/templates/) | Specs and Cloud-Init configs for each template |
| [Known Issues](docs/hardware/proxmox-setup.md#known-issues) | Open issues and workarounds |

---

## Repo Structure

```
proxmox-data-center/
├── README.md
├── .gitignore
├── docs/
│   ├── hardware/
│   │   └── proxmox-setup.md
│   ├── network/
│   │   ├── topology.md
│   │   └── ip-allocation.md
│   ├── runbooks/
│   │   ├── add-docker-compose-vm.md
│   │   ├── add-k3s-node.md
│   │   ├── add-postgres-vm.md
│   │   ├── add-dev-station-vm.md
│   │   └── idrac-access.md
│   ├── templates/
│   │   ├── docker-compose.md
│   │   ├── k3s-node.md
│   │   ├── postgres.md
│   │   └── dev-station.md
│   └── decisions/
│       ├── ADR-001-k3s-over-full-kubernetes.md
│       ├── ADR-002-subnet-routing-move-to-raspi.md
│       ├── ADR-003-cloud-init-over-proxmox-templates.md
│       └── ADR-004-k3s-worker-node-template-hardware-reasoning.md
└── terraform/
    ├── main.tf
    ├── providers.tf
    ├── variables.tf
    └── modules/
        ├── docker-compose/
        ├── k3s-node/
        ├── postgres/
        └── dev-station/
```
