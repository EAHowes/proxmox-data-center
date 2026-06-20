# IP Allocation PUBLIC FACING

**Subnet:** 192.168.0.0/24  
**Gateway:** 192.168.0.1  
**DNS:** 192.168.0.1 (router)  
**Last updated:** June 2026

> This is a template showing the IP range structure and naming conventions used in this server. MAC addresses and Tailscale IPs are maintained privately.

---

## Range Summary

| Range | Purpose |
|-------|---------|
| `192.168.0.1` | Router |
| `192.168.0.2–99` | Reserved / unallocated |
| `192.168.0.100–109` | Physical infrastructure (Proxmox host, iDRAC) |
| `192.168.0.110–139` | k3s nodes |
| `192.168.0.140–169` | Microservice VMs |
| `192.168.0.170–189` | Database VMs |
| `192.168.0.190–199` | Dev station VMs |
| `192.168.0.200–219` | Infrastructure services |
| `192.168.0.220–254` | DHCP / unmanaged devices |

---

## Physical Infrastructure (100–109)

| IP | Hostname | Device | Role | Notes |
|----|----------|--------|------|-------|
| `192.168.0.1` | — | TP-Link AX1300 | Router / gateway / DNS | Wi-Fi 6, AP isolation disabled |
| `192.168.0.103` | `proxmox-datacenter` | Dell PowerEdge R510 | Proxmox VE host | NIC1 (nic0) |
| `192.168.0.104` | — | — | *Reserved* | — |
| `192.168.0.105` | — | Dell PowerEdge R510 | iDRAC6 Enterprise | Dedicated NIC · local only |
| `192.168.0.106–109` | — | — | *Reserved for physical hosts* | — |

---

## k3s Nodes (110–139)

| IP | Hostname | Template | Role | Status |
|----|----------|----------|------|--------|
| `192.168.0.110` | `k3s-worker-01` | `tmpl-k3s-node` | Worker node | *Not yet deployed* |
| `192.168.0.111` | `k3s-worker-02` | `tmpl-k3s-node` | Worker node | *Not yet deployed* |
| `192.168.0.112` | `k3s-worker-03` | `tmpl-k3s-node` | Worker node | *Not yet deployed* |
| `192.168.0.113–139` | — | — | *Reserved for k3s nodes* | — |

---

## Microservice VMs (140–169)

| IP | Hostname | Template | Role | Status |
|----|----------|----------|------|--------|
| `192.168.0.140` | `api-prod-01` | `tmpl-microservice` | *First service slot* | *Not yet deployed* |
| `192.168.0.141–169` | — | — | *Reserved for microservice VMs* | — |

---

## Database VMs (170–189)

| IP | Hostname | Template | Role | Status |
|----|----------|----------|------|--------|
| `192.168.0.170` | `postgres-prod-01` | `tmpl-postgres` | *First DB slot* | *Not yet deployed* |
| `192.168.0.171–189` | — | — | *Reserved for database VMs* | — |

---

## Dev Station VMs (190–199)

| IP | Hostname | Template | Role | Status |
|----|----------|----------|------|--------|
| `192.168.0.190` | `dev-01` | `tmpl-dev-station` | Primary dev environment | *Not yet deployed* |
| `192.168.0.191–199` | — | — | *Reserved for dev stations* | — |

---

## Infrastructure Services (200–219)

| IP | Hostname | Template | Role | Status |
|----|----------|----------|------|--------|
| `192.168.0.200` | `pihole-01` | `tmpl-microservice` | Pi-hole DNS | *Not yet deployed* |
| `192.168.0.201–219` | — | — | *Reserved for infrastructure services* | — |

---

## Tailscale Addresses (100.x.x.x)

| Hostname | Device | Notes |
|----------|--------|-------|
| `proxmox-datacenter` | Dell PowerEdge R510 | Proxmox host |
| `ethan-fedora` | Fedora workstation | Primary client machine |
| `k3s-raspi4b-1` | Raspberry Pi 4B | k3s node · subnet router for `192.168.0.0/24` |
| `omen-server` | Omen server | — |

---

## Naming Convention

All VMs follow the pattern: `{role}-{env}-{index}`

| Segment | Values | Example |
|---------|--------|---------|
| `role` | `api`, `postgres`, `k3s`, `dev`, `pihole`, `nginx`, `netbox`, `grafana` | `postgres` |
| `env` | `prod`, `dev`, `staging` | `prod` |
| `index` | Two-digit zero-padded integer | `01` |

Full example: `postgres-prod-01`, `api-dev-03`, `k3s-worker-02`

Templates are prefixed with `tmpl-`: `tmpl-postgres`, `tmpl-k3s-node`, etc.

---

> **Security note:** MAC addresses and Tailscale IPs have been redacted. Real values are maintained privately.

*See also: [topology.md](topology.md) · [Hardware & Setup](../hardware/proxmox-setup.md)*
