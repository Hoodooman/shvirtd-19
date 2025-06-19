Решение Задание 1

![yc](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task2/Task1_screen_yc.png)

![curl](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task2/Task1_screen_curl.png)

Ресурс "platform" исправлено:
- параметр platform_id = "standard-v1";
- cores = 2;
- ssh-keys = "ubuntu:${var.vms_ssh_public_root_key}".


preemptible = true – Использование прерываемых ВМ, в 3-5 раз дешевле не прерываемых.</t>
core_fraction = 5 – Ограничение доли vCPU (5%), опять экономит бюджет.

Решение Задание 2, 3
[Облачная инфраструктура Terraform/Task2/src](https://github.com/Hoodooman/shvirtd-19/tree/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task2/src)

Решение Задание 4 
![Task4](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task2/Task4.png)

Решение Задание 5
[locals.tf](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task2/src/locals.tf)

![Task5](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task2/Task5.png)

Решение Задание 6
[vms_platform.tf](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task2/src/vms_platform.tf)

![Task6](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task2/Task6.png)

Решение Задание 7
![Task7](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task2/Task7.png)

Решение Задание 8
![Task8](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task2/Task7.png)

