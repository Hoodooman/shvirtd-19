# Решение Задание 1

1. Создадим namespace shkube-hw:

![Task1_1](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task3/Task1/data/Task1_1.png)

2. Деплоим [deployment_1_repl.yml](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task3/Task1/deployment_1_repl.yml)
```bash
kubectl apply -f deployment_1_repl.yml
```

3. Смотрим описание пода и логи контейнера

![Task1_2](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task3/Task1/data/Task1_2.png)

Видим что порт 80 занят nginx, необходимо переопределить http порт для multitool

```yaml
        env:   # Исправляем ошибку конфликта портов nginx
        - name: HTTP_PORT
          value: "1180"
```

![Task1_3](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task3/Task1/data/Task1_3.png)

4. Масштабируем до 2 реплик

![Task1_4](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task3/Task1/data/Task1_4.png)

5. Создаем сервис [service.yml](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task3/Task1/service.yml) с типом ClusterIP для внутреннего доступа в кластере
```bash
kubectl apply -f service.yml
```
![Task1_5](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task3/Task1/data/Task1_5.png)

6. Создаем под [multitool-pod.yml](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task3/Task1/multitool-pod.yml) для тестирования контейнеров нашего приложения

![Task1_6](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task3/Task1/data/Task1_6.png)

# Решение Задание 2

1. Разворачиваем nginx [nginx-deployment.yml](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task3/Task2/nginx-deployment.yml)

![Task2_1](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task3/Task2/data/Task2_1.png)

2. Видим что nginx не запускается

![Task2_2](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task3/Task2/data/Task2_2.png)

3. Создаем сервис [nginx-service.yml](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task3/Task2/nginx-service.yml), видим запуск nginx, под в статусе Running
```bash
kubectl apply -f nginx-service.yml
```
![Task2_3](https://github.com/Hoodooman/shvirtd-19/blob/main/Kubernetes/Task3/Task2/data/Task2_3.png)

