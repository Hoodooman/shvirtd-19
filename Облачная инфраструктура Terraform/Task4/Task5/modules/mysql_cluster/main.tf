resource "yandex_mdb_mysql_cluster" "this" {
  name        = var.cluster_name
  environment = "PRESTABLE"
  network_id  = var.network_id
  version     = "8.0"

  resources {
    resource_preset_id = "b1.medium" # Минимальная конфигурация
    disk_type_id      = "network-hdd"
    disk_size         = 10 # Минимальный размер диска
  }

  mysql_config = {
    sql_mode                      = "ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
    innodb_print_all_deadlocks    = true
  }

  dynamic "host" {
    for_each = var.ha ? [1, 2] : [1]
    content {
      zone      = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.subnet[1].id
    }
  }
}

resource "yandex_vpc_subnet" "subnet" {
  count          = 3
  name           = "${var.cluster_name}-subnet-${substr("abd", count.index, 1)}"
  zone           = "ru-central1-${substr("abd", count.index, 1)}"
  network_id     = var.network_id
  v4_cidr_blocks = ["10.1${count.index}.0.0/24"]
}