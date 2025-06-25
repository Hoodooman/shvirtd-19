variable "each_vm" {
  type = list(object({
    vm_name    = string
    cpu        = number
    ram        = number
    disk_volume = number
  }))
  default = [
    {
      vm_name    = "main"
      cpu        = 2
      ram        = 2
      disk_volume = 6
    },
    {
      vm_name    = "replica"
      cpu        = 2
      ram        = 1
      disk_volume = 5
    }
  ]
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
  #default = "f2e2resm5pilamg43ak1"
}

resource "yandex_compute_instance" "db_vms" {
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  name        = each.value.vm_name
  platform_id = "standard-v1"
  
  resources {
    cores  = each.value.cpu
    memory = each.value.ram
    core_fraction = var.vms_resources.db.core_fraction	
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
	  type     = "network-hdd"
      size     = each.value.disk_volume
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id 
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id] 
  }

  metadata = {
    serial-port-enable = 1  
    #ssh-keys = "ubuntu:${var.vms_ssh_public_root_key}"
    ssh-keys = "ubuntu:${local.ssh_key}"	
  }
}

 
