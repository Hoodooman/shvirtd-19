resource "yandex_compute_disk" "storage_disks" {
  count = var.storage_disks_count

  name     = "${var.storage_name}-${count.index}"
  type     = var.storage_disk_type
  zone     = var.zone
  size     = var.storage_disk_size
}

resource "yandex_compute_instance" "storage" {
  name        = var.storage_instance_name
  platform_id = var.storage_platform_id
  zone        = var.zone

  resources {
    cores         = var.storage_instance_cores
    memory        = var.storage_instance_memory
    core_fraction = var.storage_instance_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = var.boot_disk_type
      size     = var.boot_disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disks
    content {
      disk_id = secondary_disk.value.id
    }
  }

  metadata = {
    serial-port-enable = var.serial_port_enable
    ssh-keys          = "ubuntu:${local.ssh_key}"
  }
}