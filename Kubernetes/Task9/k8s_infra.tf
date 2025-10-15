data "template_file" "mastersinit" {
  template = file("masters-init.yml")
  vars = {
    ssh_keys = join("\n", [for key in var.ssh_public_keys: "      - ${key}"])
  }  
}

data "template_file" "workersinit" {
  template = file("workers-init.yml")
  vars = {
    ssh_keys = join("\n", [for key in var.ssh_public_keys: "      - ${key}"])
  }  
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "masters" {
  # depends_on = [null_resource.offline_script]
  count = var.cnt_master
  name  = "master-${count.index}"
  # Используем длину списка зон для корректного распределения
  zone  = "ru-central1-${element(local.zones, count.index % length(local.zones))}"
  platform_id       = "standard-v3"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.k8s-subnets[0].id
    nat       = true # Публичный IP для доступа
  }

  metadata = {
    user-data          = data.template_file.mastersinit.rendered
    serial-port-enable = 1
  }

  scheduling_policy {
    preemptible = true # Control-plane не должен быть прерываемым !!!
  }
  
  connection {
    type        = "ssh" 
    user        = "ubuntu"
    private_key = file(pathexpand("~/.ssh/${var.pvk}"))
    host        = yandex_compute_instance.masters[0].network_interface.0.nat_ip_address
  }    

  provisioner "remote-exec" {
    inline = [
      "timeout 180 bash -c 'while [ ! -f ${var.homedir}/install_complete.txt ]; do sleep 1; done'" // Ожидание создания файла не более 3 минут
    ]
  }

}

locals {
  zones = ["a", "b", "d"] # Список доступных зон, в помощь: yc compute zone list
}

resource "yandex_compute_instance" "workers" {
  count = var.cnt_worker
  name  = "worker-${count.index}"
  # Используем длину списка зон для корректного распределения
  zone  = "ru-central1-${element(local.zones, count.index % length(local.zones))}"
  platform_id       = "standard-v3"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = 10 # Больший размер диска для рабочих нагрузок
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.k8s-subnets[count.index % 3].id
    nat       = false # Worker-нодам не нужны публичные IP
  }

  metadata = {
    user-data          = data.template_file.workersinit.rendered
    serial-port-enable = 1
  }  

  scheduling_policy {
    preemptible = true # Можно использовать прерываемые ВМ для экономии
  }
}

resource "null_resource" "private_key_ansible" {
  depends_on = [yandex_compute_instance.masters, yandex_compute_instance.workers]
  connection {
    type        = "ssh" 
    user        = "ubuntu"
    private_key = file(pathexpand("~/.ssh/${var.pvk}"))
    host        = yandex_compute_instance.masters[0].network_interface.0.nat_ip_address
  }

  provisioner "file" {
    source      = pathexpand("~/.ssh/${var.pvk}")
    destination = "${var.homedir}/.ssh/${var.pvk}"    # Remote destination directory
  }

  provisioner "remote-exec" {
    inline = ["sudo chmod 600 ${var.homedir}/.ssh/${var.pvk}"] # Creates the directory if it doesn't exist
  }

  provisioner "file" {
    source      = "./ansible/inventory/hosts.yaml"
    destination = "${var.homedir}/kubespray/inventory/mycluster/hosts.yaml"  # Temporary, writable location
  }

  # # Step 2: Move the file and set ownership via sudo
  # provisioner "remote-exec" {
  #   inline = [
  #     "mv /tmp/hosts.yaml ${var.homedir}/kubespray/inventory/mycluster/hosts.yaml",
  #   ]
  # }
}

resource "null_resource" "proxy" {
  depends_on = [yandex_compute_instance.masters, null_resource.private_key_ansible]
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/inventory/hosts.yaml --become --become-user=root ansible/setup_proxy.yml"
  }
}

resource "null_resource" "kubeadm_config" {
  depends_on = [yandex_compute_instance.masters, yandex_compute_instance.workers, null_resource.private_key_ansible, null_resource.proxy]

  provisioner "remote-exec" {
  connection {
    type        = "ssh" 
    user        = "ubuntu"
    private_key = file(pathexpand("~/.ssh/${var.pvk}"))
    host        = yandex_compute_instance.masters[0].network_interface.0.nat_ip_address
  }    
    inline = [
      ". ${var.homedir}/kubespray/venv/bin/activate",
      "cd ${var.homedir}/kubespray",
      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml -vvvvv"
    ]
  }
}