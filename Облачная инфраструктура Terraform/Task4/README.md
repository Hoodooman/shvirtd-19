# Решение задание 1

![1](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task1.png)

![2](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task1_2.png)

![3](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task1_3.png)

[Код Задание 1](https://github.com/Hoodooman/shvirtd-19/tree/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task1)

# Решение задание 2

[Код Задание 2](https://github.com/Hoodooman/shvirtd-19/tree/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task2)

[readme vps module](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task2/modules/vpc/README.md)

# Решение задание 3
![remove](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task3_1.png)

# 1. Вывод списка ресурсов
terraform state list

# 2. Удаление модулей
terraform state rm module.vpc_dev
terraform state rm module.analytics_vm
terraform state rm module.marketing_vm

# 3. Импорт VPC
terraform import module.vpc_dev.yandex_vpc_network.this enpigs0p8mabfrquoo92
terraform import module.vpc_dev.yandex_vpc_subnet.public e9bs137vhdiblju8krdn

# 4. Импорт analytics_vm
terraform import module.analytics_vm.data.yandex_compute_image.my_image fd88h22en6kf0uhptpk5

# 5. Импорт marketing_vm
terraform import module.marketing_vm.data.yandex_compute_image.my_image fd88h22en6kf0uhptpk5

# 6. Проверка
terraform plan

![plan](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task3_2.png)

# Решение задание 4

[Код Задание 4](https://github.com/Hoodooman/shvirtd-19/tree/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task4)

[План выполнения](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task4/data/plan4.txt)

![1](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task4/data/Task4_1.png)

![2](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task4/data/Task4_2.png)

# Решение задание 5

![Task0_1](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task5/data/Task0_1.png)

![Task0_2](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task5/data/Task0_2.png)

[terraform plan](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task5/data/t_plan_1host.txt)

![Task1_1](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task5/data/Task1_1.png)

![Task1_2](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task5/data/Task1_2.png)

![Task1_3](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task5/data/Task1_3.png)

![Task1_4](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task5/data/Task1_4.png)

![Task1_5](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task5/data/Task1_5.png)

[Ссылка на код](https://github.com/Hoodooman/shvirtd-19/tree/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task5)

# Решение задание 6

[Ссылка на код](https://github.com/Hoodooman/shvirtd-19/tree/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task6)

# Решение задание 7

![Task7_1](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task7/data/Taskk7_1.png)

[Ссылка на код](https://github.com/Hoodooman/shvirtd-19/tree/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task7)

# Решение задание 8

![Task8](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task8/data/Task8.png)

![Task8_2](https://github.com/Hoodooman/shvirtd-19/blob/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task8/data/Task8_2.png)

[Ссылка на код](https://github.com/Hoodooman/shvirtd-19/tree/terraform-04/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task4/Task8)

# Ссылка на ветку terraform-04

[Ветка terraform-04](https://github.com/Hoodooman/shvirtd-19/tree/terraform-04)








