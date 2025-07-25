variable "access_key" {}
variable "secret_key" {}

module "vm" {
  source        = "./modules/vm"
  env_name      = "hw-04-remote"
  instance_name = "wm-1"
  owner         = "alexz"
  access_key = var.access_key
  secret_key = var.secret_key
} 