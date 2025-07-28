module "vpc" {
  source = "./modules/vpc"
  vpc_name      = var.vpc_name
  default_zone  = var.default_zone
  default_cidr  = var.default_cidr
}

module "vm" {
  source        = "./modules/vm"
  env_name      = "hw-04-remote"
  instance_name = "wm-1"
  owner         = "alexz"
  network_id    = module.vpc.network_id
  subnet_id     = module.vpc.subnet_id
  depends_on    = [module.vpc]
} 