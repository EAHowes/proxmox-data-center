module "k3s_worker_01" {
  source         = "./modules/k3s-node"
  vm_id          = 201
  name           = "k3s-worker-01"
  ip             = "192.168.0.121/24"
  ssh_public_key = var.ssh_public_key
}

module "k3s_worker_02" {
  source         = "./modules/k3s-node"
  vm_id          = 202
  name           = "k3s-worker-02"
  ip             = "192.168.0.122/24"
  ssh_public_key = var.ssh_public_key
}

module "k3s_worker_03" {
  source         = "./modules/k3s-node"
  vm_id          = 203
  name           = "k3s-worker-03"
  ip             = "192.168.0.123/24"
  ssh_public_key = var.ssh_public_key
}

module "k3s_worker_04" {
  source         = "./modules/k3s-node"
  vm_id          = 204
  name           = "k3s-worker-04"
  ip             = "192.168.0.124/24"
  ssh_public_key = var.ssh_public_key
}

module "docker_compose_01" {
  source         = "./modules/docker-compose"
  vm_id          = 301
  name           = "docker-compose-01"
  ip             = "192.168.0.131/24"
  ssh_public_key = var.ssh_public_key
}

module "postgres_dev_01" {
  source         = "./modules/postgres"
  vm_id          = 401
  name           = "postgres-dev-01"
  ip             = "192.168.0.141/24"
  ssh_public_key = var.ssh_public_key
}

module "dev_station_01" {
  source         = "./modules/dev-station"
  vm_id          = 501
  name           = "dev-station-01"
  ip             = "192.168.0.151/24"
  ssh_public_key = var.ssh_public_key
}
