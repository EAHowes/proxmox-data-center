# Cloud init over proxmox templates

With just proxmox templates I would have to go through the installer for each VM that I spin up. This means that I would have to open the console to set a hostname, password, ssh key, and static ip for each VM that I create. Cloud init allows for all of this to be set up in proxmox before the VM is created so that after creation of the VM I can instantly SSH into it without touching the console every time. 

Cloud init works by creating a virtual CD drive attached to the VM that contains a config file. After the machine boots, cloud init reads from the virtual CD / config file and applies all the settings automatically.

|proxmox templates|cloud init|
|---|---|
|manual config via console| automated config with specs decided before VM boot|
