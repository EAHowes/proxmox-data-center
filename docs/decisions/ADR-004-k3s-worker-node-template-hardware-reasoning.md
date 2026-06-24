# k3s worker node template hardware reasoning

> Why was each VM spec chosen?

|Decision|Reason|
|---|---|
|2 CPU cores| Since my machine has about 16 threads total, 2 cores per worker allows about 6 workers to run simultaniously.|
|4 GB ram| My machine has about 64 gigs ram so this allows for multiple workers to be up at the same time while giving enough overhead for proxmox itself. 4 gigs ram is also enough for most k3s workers|
|32 GB disk| allows enough space for the OS, k3s install, container images, and logs. data is also not typically stored on individual pods |
|VirtIO | Is paravirtualized so the VM knows that its running in a hypervisor. This allows for optimized communication rather than the machine emulating real hardware |
