terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "nat_instance" {
  name        = "nat-instance"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20    
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      size     = 10
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat        = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/shvirtd-19_pvk.pub")}"
  }

  scheduling_policy {
    preemptible = true # Можно использовать прерываемые ВМ для экономии
  }  
}

resource "yandex_compute_instance" "public_vm" {
  name        = "public-vm"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20      
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/shvirtd-19_pvk.pub")}"
  }

  scheduling_policy {
    preemptible = true # Можно использовать прерываемые ВМ для экономии
  }  
}

resource "yandex_compute_instance" "private_vm" {
  name        = "private-vm"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20      
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/shvirtd-19_pvk.pub")}"
  }

  scheduling_policy {
    preemptible = true # Можно использовать прерываемые ВМ для экономии
  }    
}

resource "null_resource" "cp_private_key_on_public_host" {
  depends_on = [yandex_compute_instance.public_vm]
  connection {
    type        = "ssh" 
    user        = "ubuntu"
    private_key = file(pathexpand("~/.ssh/${var.pvk}"))
    host        = yandex_compute_instance.public_vm.network_interface.0.nat_ip_address
  }

  provisioner "file" {
    source      = pathexpand("~/.ssh/${var.pvk}")
    destination = "${var.homedir}/.ssh/${var.pvk}"    # Remote destination directory
  }

  provisioner "remote-exec" {
    inline = ["sudo chmod 600 ${var.homedir}/.ssh/${var.pvk}"] # Creates the directory if it doesn't exist
  }

}

output "public_vm_ip" {
  value = yandex_compute_instance.public_vm.network_interface.0.nat_ip_address
}

output "private_vm_ip" {
  value = yandex_compute_instance.private_vm.network_interface.0.ip_address
}

resource "local_file" "ssh_connect" {
   content = templatefile("${path.module}/ssh_connect.tftpl",
     {
      public_ip  = yandex_compute_instance.public_vm.network_interface.0.nat_ip_address
      private_ip = yandex_compute_instance.private_vm.network_interface.0.ip_address

     }
   )
   filename = "${path.module}/ssh_connect.ini"
}