# Решение Задание 1

Разворачиваем кластер MYSQL:

![1](https://github.com/Hoodooman/shvirtd-19/blob/main/CloudProvider/Task4/data/mysql_1.png)

![2](https://github.com/Hoodooman/shvirtd-19/blob/main/CloudProvider/Task4/data/mysql_2.png)

![3](https://github.com/Hoodooman/shvirtd-19/blob/main/CloudProvider/Task4/data/mysql_3.png)

Разворачиваем кластер k8s:

![4](https://github.com/Hoodooman/shvirtd-19/blob/main/CloudProvider/Task4/data/k8s_mysql_4.png)

![5](https://github.com/Hoodooman/shvirtd-19/blob/main/CloudProvider/Task4/data/k8s_mysql_5.png)

# Исправление ошибки
Добавили правила для k8s:
```
# Security group for MySQL cluster allowing K8s access
resource "yandex_vpc_security_group" "mysql_k8s_access" {
  name        = "mysql-k8s-access"
  network_id  = module.vpc.vpc_id

  ingress {
    protocol       = "TCP"
    port           = 3306
    v4_cidr_blocks = ["10.96.0.0/16", "10.112.0.0/16"] # K8s service CIDRs
    description    = "Allow MySQL access from K8s cluster"
  }

  ingress {
    protocol       = "TCP"
    port           = 3306
    v4_cidr_blocks = ["10.121.0.0/24", "10.131.0.0/24", "10.141.0.0/24"] # K8s node subnet CIDR
    description    = "Allow MySQL access from K8s nodes"
  }
}
```

![6](https://github.com/Hoodooman/shvirtd-19/blob/main/CloudProvider/Task4/data/k8s_mysql_51.png)

![7](https://github.com/Hoodooman/shvirtd-19/blob/main/CloudProvider/Task4/data/k8s_mysql_6.png)



