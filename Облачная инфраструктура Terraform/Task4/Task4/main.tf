
module "vpc_prod" {
  source   = "./modules/vpc"
  env_name = "production"
  subnets = [
    { zone = "ru-central1-d", cidr = "10.20.0.0/24" },
    { zone = "ru-central1-b", cidr = "10.30.0.0/24" },
    { zone = "ru-central1-a", cidr = "10.40.0.0/24" },
  ]
}


/*
module "vpc_dev" {
  source   = "./modules/vpc"
  env_name = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.30.0.0/24" },
  ]
}
*/
