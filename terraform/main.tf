module "networking" {
  source = "./modules/networking"

  project_id                = var.project_id
  region                   = var.region
  vpc_name                 = var.vpc_name
  management_subnet_name   = var.management_subnet_name
  restricted_subnet_name   = var.restricted_subnet_name
  management_subnet_cidr   = var.management_subnet_cidr
  restricted_subnet_cidr   = var.restricted_subnet_cidr
  nat_router_name         = var.nat_router_name
  nat_gateway_name        = var.nat_gateway_name
}

module "security" {
  source = "./modules/security"

  project_id      = var.project_id
  vpc_network_id  = module.networking.vpc_network_id
  vpc_network_name = module.networking.vpc_network_name
  internal_cidr   = var.internal_cidr
  firewall_prefix = var.firewall_prefix
}

module "compute" {
  source = "./modules/compute"

  project_id                = var.project_id
  zone                     = var.zone
  vm_name                  = var.vm_name
  vm_service_account_name  = var.vm_service_account_name
  management_subnet_name   = module.networking.management_subnet_name
  vm_internal_ip          = var.vm_internal_ip
}

module "gke" {
  source = "./modules/gke"

  project_id               = var.project_id
  zone                    = var.zone
  cluster_name            = var.cluster_name
  gke_service_account_name = var.gke_service_account_name
  vpc_network_id          = module.networking.vpc_network_id
  restricted_subnet_name  = module.networking.restricted_subnet_name
  master_cidr             = var.master_cidr
  management_subnet_cidr  = var.management_subnet_cidr
  node_count              = var.node_count
}

module "registry" {
  source = "./modules/registry"

  project_id     = var.project_id
  region         = var.region
  repository_name = var.repository_name
}
