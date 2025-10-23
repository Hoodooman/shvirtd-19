# Решение Задание 1

Разворачиваем приложение:
![Task1_1](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task12/data/Task1_1.png)

Создаем отсутствующие пространства имен, продолжаем установку:
![Task1_2](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task12/data/Task1_2.png)

Видим,что приложение auth-db все в порядке, но приложение web-consumer не может достучаться до auth-db по имени хоста.
![Task1_2_3](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task12/data/Task1_2_3.png)

Проблема в том что приложения развернуты в разных пространствах имен, нам необходиму явно указать путь.
![Task1_3](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task12/data/Task1_3.png)

Исправляем манифест [task.yaml](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task12/task.yaml), запускаем приложение повторно. Видим ошибка устранена.
![Task1_4](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task12/data/Task1_4.png)
