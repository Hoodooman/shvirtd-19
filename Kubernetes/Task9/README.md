# Решение Задание 1

![Task1](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task1.png)

![Task1_2](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task1_2.png)

![Task1_3](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task1_3.png)

# Решение Задание 2

![Task2_1](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task2_1.png)

![Task2_2](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task2_2.png)

![Task2_3](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task2_3.png)

![Task2_4](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task2_4.png)

Запускаем конфигурирование HAProxy+keepalive [kubernetes-lb](https://github.com/Hoodooman/shvirtd-19/tree/main/Kubernetes/Task9/ansible/kubernetes-lb)

```bash
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory/mycluster/kubernetes-lb/hosts.ini --private-key=~/.ssh/shvirtd-19_pvk inventory/mycluster/kubernetes-lb/playbook.yml
```
![Task2_5](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task2_5.png)

Проверяем cluster VIP

![Task2_6](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task2_6.png)

![Task2_7](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task9/data/Task2_7.png)

