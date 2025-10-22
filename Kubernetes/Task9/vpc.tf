# Создание облачной сети
resource "yandex_vpc_network" "k8s-network" {
  name        = "k8s-network"
  description = "Сеть для Kubernetes кластера"
}

# Создание подсетей в трёх зонах доступности
resource "yandex_vpc_subnet" "k8s-private" {
  count          = 3
  name           = "k8s-prv-subnet-${count.index}"
  zone           = "ru-central1-${element(["a", "b", "d"], count.index)}"
  network_id     = yandex_vpc_network.k8s-network.id
  v4_cidr_blocks = ["10.${count.index}.0.0/16"]
  route_table_id = yandex_vpc_route_table.nat.id

}

# Создание подсетей в трёх зонах доступности
resource "yandex_vpc_subnet" "k8s-public" {
  count          = 3
  name           = "k8s-pub-subnet-${count.index}"
  zone           = "ru-central1-${element(["a", "b", "d"], count.index)}"
  network_id     = yandex_vpc_network.k8s-network.id
  v4_cidr_blocks = ["10.${count.index + 3}.0.0/16"]

}

# Создание таблицы маршрутизации
resource "yandex_vpc_route_table" "nat" {
  name       = "nat-route-table"
  network_id = yandex_vpc_network.k8s-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

# Создание NAT шлюза
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}