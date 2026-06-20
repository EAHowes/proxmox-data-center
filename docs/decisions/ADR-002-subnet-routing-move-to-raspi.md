# Subnet Routing Moved to Raspi

Originally Subnet routing was performed directly on the data center server itself. However this created a problem where if the server went down, then I was not able to open iDRAC from my local network or remote networks to bring the server back online. The Tailscale Subnet Routing blcoked my requests to the server effectively locking me out of it entirely.

This was fixed by migrating the subnet routing to a Raspberry Pi 4 that I have as a worker node in a seperate k3s cluster. The Subnet router lives seperate from the k3s install. Since the Raspi is considered an "always-on" machine in my network, it allows full 24/7 access to my data center from local and remote networks no matter the state of my proxmox data center.

# Comparisons

| Proxmox Subnet Router Host | RasPi4B Subnet Router Host |
--------------
| Not always on since the data center draws a lot of power | Always on with lower power draw |
| Can and has locked me out of the server | Will not lock me out unless a system failure shuts down the pi |
