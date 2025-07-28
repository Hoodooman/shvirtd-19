# data "terraform_remote_state" "vpc" {
#   backend = "s3"
#   config  = {
#     endpoints = {
#       s3 = "https://storage.yandexcloud.net"
#     }
    
#     shared_credentials_files = ["~/.aws/credentials"]
    
#     bucket     = "ter-hw-04" 
#     key        = "vpc/terraform.tfstate"
#     region     = "ru-central1"

#     skip_region_validation      = true
#     skip_credentials_validation = true
#     skip_requesting_account_id  = true # Необходимая опция при описании бэкенда для Terraform версии старше 
#    }
#  }

data "template_file" "cloudinit" {
  template = file("./modules/vm/cloud-init.yml")
  vars = {
    ssh_keys = join("\n", [for key in var.ssh_public_keys : "      - ${key}"])
  }
}

module "vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = var.env_name
  #network_id     = data.terraform_remote_state.vpc.outputs.network_id
  network_id     = var.network_id  
  subnet_zones   = [var.default_zone]
  #subnet_ids     = [data.terraform_remote_state.vpc.outputs.subnet_id]
  subnet_ids     = [var.subnet_id]
  instance_name  = var.instance_name
  instance_count = 1
  image_family   = var.image_family
  public_ip      = true

  labels = { 
    owner   = var.owner,
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}