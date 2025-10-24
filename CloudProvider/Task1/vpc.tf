# Создание облачной сети
resource "yandex_vpc_network" "yc-network" {
  name        = "yc-network"
  description = "Сеть для Yandex Cloud"
}

# Создание подсетей
resource "yandex_vpc_subnet" "public" {
  name           = "yc-pub-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.yc-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]

}

resource "yandex_vpc_subnet" "private" {
  name           = "yc-prv-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.yc-network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.private_rt.id
}

resource "yandex_vpc_route_table" "private_rt" {
  depends_on = ["yandex_compute_instance.nat_instance"]
  name       = "private-route-table"
  network_id = yandex_vpc_network.yc-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}
