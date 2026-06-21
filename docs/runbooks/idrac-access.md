# Runbook: Access iDRAC During Proxmox Reboot

**Last updated:** June 2026  
**Estimated time:** 2–5 minutes  
**Purpose:** Access the iDRAC6 out-of-band management interface when Proxmox is rebooting, offline, or otherwise unreachable.

---

## Background

iDRAC6 runs on a dedicated NIC independent of the Proxmox host. It is always accessible as long as the server has power including during POST, BIOS, RAID configuration, or OS reinstall. Normally iDRAC is only accessable via local networks however, because Tailscale subnet routing runs on `RaspberryPi`, iDRAC is reachable at `192.168.0.105` from any device accepting routes in the Tailnet at any time.

> For this setup, iDRAC has been configured for remote access via Tailscale. `RaspberryPi` advertises the `192.168.0.0/24` subnet so any device on your tailnet can reach `192.168.0.105` directly.

---

## Prerequisites

- Connected to the local network (`192.168.0.0/24`) via WiFi or Ethernet, **or** connected to Tailscale with routes accepted (`tailscale up --accept-routes`)

---

## Procedure

### 1. Verify Local Network Access

Confirm your machine can reach the local subnet:

```bash
ping 192.168.0.1
```

---

### 2. Access iDRAC Web Interface

Open a browser and navigate to:

```
https://192.168.0.105
```

---

### 3. Access iDRAC via SSH

SSH gives you a `racadm` shell for power control, system info, and boot management without needing Java:

```bash
ssh root@192.168.0.105
```

Useful racadm commands:

```bash
# View system information
racadm getsysinfo

# View current power state
racadm getconfig -g cfgServerPower

# Power on the server
racadm serveraction powerup

# Graceful shutdown (OS-level)
racadm serveraction graceshutdown

# Hard power off
racadm serveraction powerdown

# Power cycle (hard reboot)
racadm serveraction powercycle

# View system event log
racadm getsel

# Clear system event log
racadm clrsel

# Check NIC config
racadm getniccfg

# One-time boot to BIOS on next reboot
racadm config -g cfgServerInfo -o cfgServerFirstBootDevice BIOS

# One-time boot to PXE on next reboot
racadm config -g cfgServerInfo -o cfgServerFirstBootDevice PXE

# Ping a host from iDRAC (useful to verify network from server side)
racadm ping 192.168.0.1
```
