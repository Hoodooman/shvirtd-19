# Решение Задание 1

![tflint](https://github.com/Hoodooman/shvirtd-19/blob/terraform-05/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task5/data/Task1_src_tflint.png)

![checkov](https://github.com/Hoodooman/shvirtd-19/blob/terraform-05/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task5/data/Task1_checkov.png)


Предупреждения tflint:
- не указана версия яндекс провайдера;
- объявлена переменная, но не инициализирована;
- удаленный источник должен быть закреплен за версией, отличной по умолчанию.

Фэйлы checkov:
- убедитесь, что источники модуля Terraform используют тег с номером версии;
- убедитесь, что источники модуля Terraform используют хэш коммита.

# Решение Задание 2

![ydb](https://github.com/Hoodooman/shvirtd-19/blob/terraform-05/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task5/data/Task2_ydb.png)

![lock](https://github.com/Hoodooman/shvirtd-19/blob/terraform-05/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task5/data/Task2_lock_unlock.png)
