# Решение Задание 1

![Task1](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task1.png)

![Task1_2](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task1_2.png)

![Task1_3](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task1_3.png)

# Решение Задание 2

![Task2_1](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task2_1.png)

![Task2_2](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task2_2.png)

![Task2_3](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task2_3.png)

![Task2_4](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task2_4.png)

Запускаем конфигурирование HAProxy+keepalive

```bash
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts.ini --private-key=~/.ssh/shvirtd-19_pvk playbook.yml
```
