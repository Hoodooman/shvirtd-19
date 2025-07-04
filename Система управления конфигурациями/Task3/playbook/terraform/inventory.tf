
variable "each_vm" {
  type = list(object({
    vm_name    = string
    cpu        = number
    ram        = number
    disk_volume = number
  }))
  default = [
    {
      vm_name    = "clickhouse-01"
      cpu        = 2
      ram        = 2
      disk_volume = 5
    },
    {
      vm_name    = "vector-01"
      cpu        = 2
      ram        = 2
      disk_volume = 5
    },
    {
      vm_name    = "lighthouse-01"
      cpu        = 2
      ram        = 2
      disk_volume = 5
    }    
  ]
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
  #default = "f2e2resm5pilamg43ak1"
}

resource "yandex_compute_instance" "vms" {
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  name        = each.value.vm_name
  platform_id = "standard-v1"
  
  resources {
    cores  = each.value.cpu
    memory = each.value.ram
    core_fraction = var.vms_resources.ans.core_fraction	
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
	  type     = "network-hdd"
      size     = each.value.disk_volume
    }
  }

  scheduling_policy {
    preemptible = true  # Делаем ВМ прерываемой
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

  # Connection for provisioner
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/shvirtd19_pvk")
    host        = self.network_interface[0].nat_ip_address
  }

  # Install Python3 after VM creation
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y python3 python3-pip python3-venv",
      "sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1",
      "python3 --version"
    ]
  }  
}
 