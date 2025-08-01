module "vm" {
  source        = "./modules/vm"
  env_name      = "hw-04-remote"
  instance_name = "wm-1"
  owner         = "alexz"
} 