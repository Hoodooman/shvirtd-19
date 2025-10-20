# Решение задание 1
Запускаем деплой [deployments.yaml](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task10/deployments.yaml), проверяем сетевой трафик между сервисами.

![Task1](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task10/data/Task1.png)

Применяем сетевые политики [net-policy.yaml](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task10/net-policy.yaml), проверяем траффик.
```bash
kubectl -n app exec -it deploy/frontend -- curl -s backend
kubectl -n app exec -it deploy/frontend -- curl -s cache

kubectl -n app exec -it deploy/backend -- curl -s frontend
kubectl -n app exec -it deploy/backend -- curl -s cache

kubectl -n app exec -it deploy/cache -- curl -s frontend
kubectl -n app exec -it deploy/cache -- curl -s backend
```

![Task1_2](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task10/data/Task1_2.png)

![Task1_3](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task10/data/Task1_3.png)

Видим что политики работают, зайдем на консоль cache и пропингуем frontend, backend. Ответных пакетов нет, что соответсвует установленными сетевыми политиками.

![Task1_4](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task10/data/Task1_4.png)
