locals {
  instances = {
    platform  = yandex_compute_instance.platform
    platform2 = yandex_compute_instance.platform2
  }
}

output "network_interfaces" {
  description = "Network interfaces for all compute instances"
  value = {
    for name, instance in local.instances :
    name => {
	  instance_name  = instance.name
      ip_address     = instance.network_interface[0].ip_address
      nat_ip_address = instance.network_interface[0].nat_ip_address
      zone           = instance.zone
      fqdn           = instance.fqdn
    }
  }
}

