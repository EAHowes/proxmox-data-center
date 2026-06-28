module "k3s_worker_01" {
  source         = "./modules/k3s-node"
  vm_id          = 201
  name           = "k3s-worker-01"
  ip             = "192.168.0.121/24"
  ssh_public_key = var.ssh_public_key
}
