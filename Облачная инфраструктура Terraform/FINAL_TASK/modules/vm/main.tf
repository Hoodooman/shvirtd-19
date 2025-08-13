data "template_file" "cloudinit" {
  template = file("./modules/vm/cloud-init.yml")
  vars = {
    ssh_keys = join("\n", [for key in var.ssh_public_keys: "      - ${key}"])
  }  

}

module "vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=09144db7f136b793064f1ac593fe2ac6921932f0"
  env_name       = var.env_name
  network_id     = var.network_id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [var.subnet_id]
  instance_name  = var.instance_name
  instance_count = 1
  image_family   = var.image_family
  public_ip      = true
  labels = { 
    owner   = var.owner,
  }

  security_group_ids = [var.sec_group]

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

output "public_ip" {
  description = "public_ip"
  value       = try(module.vm.external_ip_address[0], null)
}