resource "yandex_compute_instance" "web_vms" {
  count = 2
  name  = "web-${count.index + 1}" # This will create web-1 and web-2

  depends_on = [yandex_compute_instance.db_vms] # Ensure DB VMs are created first

  platform_id = "standard-v1"
  
  resources {
    cores  = var.vms_resources.web.cores
    memory = var.vms_resources.web.memory
	core_fraction = var.vms_resources.web.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
	  type     = "network-hdd"
      size     = 5
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
