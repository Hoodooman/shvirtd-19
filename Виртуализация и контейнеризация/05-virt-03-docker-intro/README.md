## Задача 1

Сценарий выполнения задачи:
- Установите docker и docker compose plugin на свою linux рабочую станцию или ВМ.
- Если dockerhub недоступен создайте файл /etc/docker/daemon.json с содержимым: ```{"registry-mirrors": ["https://mirror.gcr.io", "https://daocloud.io", "https://c.163.com/", "https://registry.docker-cn.com"]}```
- Зарегистрируйтесь и создайте публичный репозиторий  с именем "custom-nginx" на https://hub.docker.com (ТОЛЬКО ЕСЛИ У ВАС ЕСТЬ ДОСТУП);
- скачайте образ nginx:1.21.1;
- Создайте Dockerfile и реализуйте в нем замену дефолтной индекс-страницы(/usr/share/nginx/html/index.html), на файл index.html с содержимым:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
</html>
```
- Соберите и отправьте созданный образ в свой dockerhub-репозитории c tag 1.0.0 (ТОЛЬКО ЕСЛИ ЕСТЬ ДОСТУП). 
- Предоставьте ответ в виде ссылки на https://hub.docker.com/<username_repo>/custom-nginx/general .
---
## Решение Задача 1

[https://hub.docker.com/repository/docker/popmatrix007/custom-nginx/general](https://hub.docker.com/repository/docker/popmatrix007/custom-nginx/general)

## Решение Задача 2
![Task2](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%92%D0%B8%D1%80%D1%82%D1%83%D0%B0%D0%BB%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D1%8F%20%D0%B8%20%D0%BA%D0%BE%D0%BD%D1%82%D0%B5%D0%B9%D0%BD%D0%B5%D1%80%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D1%8F/05-virt-03-docker-intro/task2.png)

## Решение Задача 3
- 1
```
devops@shvirtd-19:~/05-virt-03-docker-intro/task1/custom-nginx$ docker start custom-nginx-t2
custom-nginx-t2
devops@shvirtd-19:~/05-virt-03-docker-intro/task1/custom-nginx$ docker attach custom-nginx-t2
```
- 2
```
^C2025/05/19 08:47:08 [notice] 1#1: signal 2 (SIGINT) received, exiting
2025/05/19 08:47:08 [notice] 24#24: exiting
2025/05/19 08:47:08 [notice] 25#25: exiting
2025/05/19 08:47:08 [notice] 24#24: exit
2025/05/19 08:47:08 [notice] 25#25: exit
2025/05/19 08:47:08 [notice] 1#1: signal 17 (SIGCHLD) received from 25
2025/05/19 08:47:08 [notice] 1#1: worker process 24 exited with code 0
2025/05/19 08:47:08 [notice] 1#1: worker process 25 exited with code 0
2025/05/19 08:47:08 [notice] 1#1: exit
```
- 3
```
devops@shvirtd-19:~/05-virt-03-docker-intro/task1/custom-nginx$ docker ps -a
CONTAINER ID   IMAGE                COMMAND                  CREATED        STATUS                          PORTS     NAMES
8f811c471ec9   custom-nginx:1.0.0   "/docker-entrypoint.…"   21 hours ago   Exited (0) About a minute ago             custom-nginx-t2

Контейнер остановился, потому что Ctrl+C отправляет сигнал SIGINT процессу внутри контейнера, и если этот процесс завершается, контейнер также останавливается.
```
- 4
```
devops@shvirtd-19:~/05-virt-03-docker-intro/task1/custom-nginx$ docker start custom-nginx-t2 
custom-nginx-t2
```
- 5
```
devops@shvirtd-19:~/05-virt-03-docker-intro/task1/custom-nginx$ docker exec -it custom-nginx-t2 bash
```
- 6
```
root@8f811c471ec9:/# apt-get update && apt-get install -y nano
```
- 7
```
root@8f811c471ec9:/# nano /etc/nginx/conf.d/default.conf

server {
    listen       81;
    listen  [::]:80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
```
- 8
```
root@8f811c471ec9:/# nginx -s reload
2025/05/19 08:53:34 [notice] 313#313: signal process started
root@8f811c471ec9:/# curl http://127.0.0.1:80
curl: (7) Failed to connect to 127.0.0.1 port 80: Connection refused
root@8f811c471ec9:/# curl http://127.0.0.1:81
<html>
<head>
Holla, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
</html>
```
- 9
```
root@8f811c471ec9:/# exit
```
- 10
```
devops@shvirtd-19:~/05-virt-03-docker-intro/task1/custom-nginx$ ss -tlpn | grep 127.0.0.1:8080
LISTEN 0      4096       127.0.0.1:8080       0.0.0.0:*
devops@shvirtd-19:~/05-virt-03-docker-intro/task1/custom-nginx$ docker port custom-nginx-t2
80/tcp -> 127.0.0.1:8080
devops@shvirtd-19:~/05-virt-03-docker-intro/task1/custom-nginx$ curl http://127.0.0.1:8080
curl: (56) Recv failure: Connection reset by peer

Порт контейнера 80 проброшен на порт хоста 8080, отсюда пусто nginx в контейнере слушает 81 порт.
```
- 11
```
devops@shvirtd-19:~/05-virt-03-docker-intro/task1/custom-nginx$ docker stop custom-nginx-t2
custom-nginx-t2
devops@shvirtd-19:~/05-virt-03-docker-intro/task1/custom-nginx$ docker run -d -p 8080:81 --name custom-nginx-t2 nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
254e724d7786: Pull complete
913115292750: Pull complete
3e544d53ce49: Pull complete
4f21ed9ac0c0: Pull complete
d38f2ef2d6f2: Pull complete
40a6e9f4e456: Pull complete
d3dc5ec71e9d: Pull complete
Digest: sha256:c15da6c91de8d2f436196f3a768483ad32c258ed4e1beb3d367a27ed67253e66
Status: Downloaded newer image for nginx:latest
docker: Error response from daemon: Conflict. The container name "/custom-nginx-t2" is already in use by container "8f811c471ec934c8ca11cab5d8abfd5c9e2477413278f6ad712506164fb8aa79". You have to remove (or rename) that container to be able to reuse that name.
See 'docker run --help'.
```
- 12
```
devops@shvirtd-19:~/05-virt-03-docker-intro/task1/custom-nginx$ docker start custom-nginx-t2
custom-nginx-t2
devops@shvirtd-19:~/05-virt-03-docker-intro/task1/custom-nginx$ docker rm -f custom-nginx-t2
custom-nginx-t2
devops@shvirtd-19:~/05-virt-03-docker-intro/task1/custom-nginx$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

## Решение Задача 4 

![Task4](https://github.com/Hoodooman/shvirtd-19/blob/main/%D0%92%D0%B8%D1%80%D1%82%D1%83%D0%B0%D0%BB%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D1%8F%20%D0%B8%20%D0%BA%D0%BE%D0%BD%D1%82%D0%B5%D0%B9%D0%BD%D0%B5%D1%80%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D1%8F/05-virt-03-docker-intro/Task4.png)

## Решение Задача 5










