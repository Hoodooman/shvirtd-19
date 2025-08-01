module "vpc" {
  source = "./modules/vpc"
  vpc_name      = var.vpc_name
  default_zone  = var.default_zone
  default_cidr  = var.default_cidr
}