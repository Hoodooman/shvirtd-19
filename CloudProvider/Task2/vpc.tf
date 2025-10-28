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
  v4_cidr_blocks = ["192.168.0.0/24"]

}