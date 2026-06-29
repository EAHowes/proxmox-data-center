# Dev Station Template

> All specs, packages, and configs for a base development environment from template.

**Base OS:** Ubuntu Server 24.04 LTS

---

## VM Specifications

| Setting | Value |
|---------|-------|
| CPU | 2 cores (x86-64-v2) |
| Memory | 4096 MB |
| Disk | 34 GB, VirtIO SCSI, Write Back cache, discard on |
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
| git | Version control |
| curl | HTTP utility |
| wget | HTTP utility |
| unzip / zip | Archive utilities |
| build-essential | C/C++ compiler toolchain (gcc, g++, make) |
| ripgrep | Fast grep alternative |
| fzf | Fuzzy finder |
| fd-find | Fast find alternative |
| htop | Interactive process monitor |
| tree | Directory tree viewer |
| jq | JSON processor |
| tmux | Terminal multiplexer |
| neovim | Text editor (v0.9.5 via neovim-ppa/stable) |
| python3 + pip + venv | Python 3 runtime and package management |
| nodejs + npm | Node.js LTS via nvm |
| rustup | Rust toolchain manager |
| golang | Go runtime |
| openjdk-21-jdk | Java 21 JDK |
| docker + docker-compose | Container runtime and compose plugin |

---

## System Configuration

**Swap:** Default (not disabled)

**Shell:** bash (default)

**nvm:** Installed to `~/.nvm`, sourced via `~/.bashrc`. Node.js LTS installed and set as default.

**rustup:** Installed to `~/.cargo`, sourced via `~/.bashrc`. Stable toolchain set as default.

**docker:** `yart` user added to the `docker` group — no `sudo` required for docker commands after first login.

**Notes:**
- No dotfiles or editor config pre-applied — configure per-instance after clone
- `growpart` / `resize2fs` may be needed if cloning to a larger disk than template size
