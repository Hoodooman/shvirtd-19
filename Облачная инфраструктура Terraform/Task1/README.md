## Решение Задача 1
![terraform](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task1/terraform.png)

2. Секреты хранятся в personal.auto.tfvars
3. "name": "random_string"
   "result": "K2AXBImZ88XqvkTF"

  4.<br> ![validate](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task1/validate.png)
- не указан тип провайдера.
- имя провайдра должно начинаться с буквенных символов или с нижнего подчеркивания.
- нет такого ресурса, ресурс не задекларирован в корневом модуле.

5. [main.tf](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task1/main.tf)

![docker_ps](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task1/docker_ps.png)

6. --auto-appruve.
Автоматически подтверждает применение изменений без запроса подтверждения у пользователя, нет возможности проверить план изменений.<br> Критично для продакшн контура.
Этот ключ полезен в CI/CD пайплайнах или скриптах, где интерактивное подтверждение невозможно.
![6](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task1/auto_appruve.png)

7. terraform.tfstate
![7](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D0%B0%D1%8F%20%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0%20Terraform/Task1/tfstate_after_destroy.png)

8. keep_locally<br>
В коде используется ресурс docker_image с параметром keep_locally = true, это означает что docker образ при операции destroy не удалется.<br> 
[keep_locally](https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs/resources/image#keep_locally-1)
