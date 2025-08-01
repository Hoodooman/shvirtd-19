resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

# Шаблон cloud-init с переменной для SSH-ключа
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    ssh_keys = join("\n", [for key in var.ssh_public_keys : "      - ${key}"])
  }
}



# ВМ для проекта marketing
module "marketing_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "marketing"
  network_id     = yandex_vpc_network.develop.id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [yandex_vpc_subnet.develop.id]
  instance_name  = "marketing-web"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = { 
    owner   = "marketing-team",
    project = "marketing",
    vm_role = "frontend"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

# ВМ для проекта analytics
module "analytics_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "analytics"
  network_id     = yandex_vpc_network.develop.id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [yandex_vpc_subnet.develop.id]
  instance_name  = "analytics-server"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = { 
    owner   = "analytics-team",
    project = "analytics",
    vm_role = "backend"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}