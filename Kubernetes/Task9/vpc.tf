# Создание облачной сети
resource "yandex_vpc_network" "k8s-network" {
  name        = "k8s-network"
  description = "Сеть для Kubernetes кластера"
}

# Создание подсетей в трёх зонах доступности
resource "yandex_vpc_subnet" "k8s-subnets" {
  count          = 3
  name           = "k8s-subnet-${count.index}"
  zone           = "ru-central1-${element(["a", "b", "d"], count.index)}"
  network_id     = yandex_vpc_network.k8s-network.id
  v4_cidr_blocks = ["10.${count.index}.0.0/16"]

}

