# Решение Задание 1

Оптимальным решением является связка GitLab CI/CD (для управления кодом и пайплайнами), Docker (для контейнеризации) и Kubernetes (для оркестрации). Это соответствует всем указанным требованиям и обеспечивает масштабируемость.
### Компоненты решения
#### Система контроля версий и CI/CD: GitLab
- Хранение кода: GitLab предоставляет облачный Git-репозиторий с поддержкой изолированных репозиториев для каждого сервиса.
- CI/CD: Встроенный механизм пайплайнов на основе файла .gitlab-ci.yml.
- Запуск сборок:<br>
  Автоматически по событиям Git (push, merge)<br>
  Вручную через UI с параметрами (ручной запуск с переменными)<br>
- Шаблоны конфигураций: Поддержка CI/CD компонентов (реusable конфигурации) и include для шаблонов.
- Безопасность:<br>
  Masked и protected переменные для секретов<br>
  Интеграция с Vault (через расширения)<br>
- Параллелизм:<br>
  Параллельный запуск jobs и stages<br>
  Возможность распределения на несколько runners

#### Платформа для сборки и развертывания: Docker + Kubernetes<br>
- Docker:<br>
  Собственные образы для сборки через Dockerfile<br>
  Интеграция с GitLab CI для сборки образов<br>
  Testcontainers для тестирования с зависимостями<br>
- Kubernetes:<br>
  Оркестрация для развертывания микросервисов<br>
  Автоматическое масштабирование и self-healing

#### Инфраструктура агентов: GitLab Runner
- Развертывание агентов:<br>
  Self-managed runners на собственных серверах (VM, k8s, bare-metal)<br>
  Поддержка Docker, Kubernetes, SSH исполнителей<br>
- Параллелизм:<br>
  Один runner может запускать несколько jobs параллельно<br>
  Поддержка распределенных сборок

###  Обоснование выбора
#### Преимущества GitLab CI/CD:
- Интеграция "все в одном": Единая платформа для кода, CI/CD и артефактов
- Гибкость конфигурации: YAML-файл с поддержкой шаблонов и параметров
- Безопасность: Встроенное управление секретами с маскировкой
- Масштабируемость: Self-hosted runners с поддержкой тысяч параллельных jobs
- Поддержка Kubernetes: Нативная интеграция для деплоя

#### Почему не другие инструменты?
 - Jenkins: Требует ручной настройки и плагинов, менее интегрирован
 - GitHub Actions: Привязка к GitHub, менее гибкие runners
 - Travis CI: Меньше возможностей для кастомных конфигураций
 - Azure Pipelines: Сложность интеграции с не-Microsoft экосистемой

# Решение Задание 2

### Компоненты решения
#### Сбор логов (Fluent Bit):
- Fluent Bit — легковесный лог-агент, который работает на каждом узле в виде DaemonSet в Kubernetes или как отдельный сервис на виртуальных машинах. Он собирает логи из stdout/stderr контейнеров и системных журналов, а также может обрабатывать структурированные и неструктурированные данные
- Преимущества: Низкое потребление ресурсов, поддержка множества входных и выходных плагинов, встроенная буферизация и возможность ротации логов
#### Буферизация и гарантированная доставка (Apache Kafka):
- Apache Kafka выступает в качестве надежного буфера между сборщиком логов и системой хранения. Она гарантирует, что логи не будут потеряны при временной недоступности Elasticsearch или Kibana
- Преимущества: Высокая пропускная способность, отказоустойчивость благодаря репликации, поддержка распределенной архитектуры и возможность обработки пиковых нагрузок
#### Хранение и индексация (Elasticsearch):
- Elasticsearch хранит и индексирует логи, обеспечивая быстрый поиск и фильтрацию. Он поддерживает полнотекстовый поиск, сложные запросы и аналитические операции
- Преимущества: Горизонтальная масштабируемость, высокая производительность, поддержка структурированных и неструктурированных данных
#### Визуализация и анализ (Kibana):
- Kibana предоставляет веб-интерфейс для поиска, фильтрации и визуализации логов. Она позволяет создавать дашборды, сохранять поисковые запросы и делиться ссылками на них
- Преимущества: Интуитивный интерфейс, поддержка сложных фильтров, интеграция с Elasticsearch
#### Дополнительные компоненты:
- Logstash (опционально) может использоваться для сложной обработки логов (например, парсинг, обогащение данных) перед отправкой в Elasticsearch
- Kubernetes для оркестрации контейнеров и управления лог-агентами через DaemonSet

### Обоснование выбора компонентов
#### Сбор логов со всех хостов:
- Fluent Bit развертывается как DaemonSet в Kubernetes или как сервис на виртуальных машинах, обеспечивая сбор логов со всех узлов. Он поддерживает различные источники, включая stdout/stderr, файлы и системные журналы
#### Минимальные требования к приложениям:
- Приложения выводят логи в stdout/stderr, что соответствует принципам 12-факторных приложений и не требует внедрения специфичных библиотек или SDK. Fluent Bit автоматически собирает эти логи через драйвер контейнерной среды (например, Docker JSON)
#### Гарантированная доставка:
- Apache Kafka обеспечивает доставку сообщений с подтверждением (acks=all), что гарантирует, что логи не будут потеряны даже при сбоях. Буферизация в Kafka также позволяет handle пиковые нагрузки и временную недоступность Elasticsearch
#### Поиск и фильтрация:
- Elasticsearch предоставляет мощный язык запросов (Query DSL) для поиска и фильтрации логов. Поддерживается полнотекстовый поиск, фильтрация по полям и сложные агрегации.
#### Пользовательский интерфейс и доступ для разработчиков:
- Kibana предлагает веб-интерфейс с возможностью создания сохраненных поисков (saved searches) и дашбордов. Разработчики могут использовать его для быстрого доступа к логам без прямого доступа к базам данных.
#### Ссылки на сохраненные поиски:
- В Kibana можно сохранять поисковые запросы и делиться ссылками на них, что удобно для совместной работы и расследования инцидентов.

### Альтернативные инструменты
- Вместо Fluent Bit можно использовать Filebeat, но Fluent Bit обладает более низким потреблением ресурсов и лучшей поддержкой Kubernetes
- Вместо Kafka можно использовать RabbitMQ, но Kafka лучше справляется с большими объемами данных и обеспечивает более высокую надежность за счет репликации
- Вместо Elasticsearch/Kibana можно использовать Loki/Grafana, но Elasticsearch предоставляет более мощные возможности поиска и анализа

# Решение Задание 3

Для обеспечения сбора и анализа состояния хостов и сервисов в микросервисной архитектуре я предлагаю использовать комбинацию Prometheus (для сбора метрик) и Grafana (для визуализации и анализа). Это решение соответствует всем указанным требованиям и широко используется в индустрии благодаря своей масштабируемости, гибкости и открытому исходному коду.
### Архитектура решения
- Prometheus отвечает за сбор и хранение метрик
- Exporters (например, Node Exporter) собирают метрики с хостов
- Grafana предоставляет пользовательский интерфейс для визуализации и анализа

### Обоснование выбора

Prometheus:
 - Pull-модель: Позволяет централизованно управлять сбором метрик и избежать перегрузки сети
 - Многомерная data model: Метрики обогащаются тегами (labels), что обеспечивает гибкость запросов и агрегации
 - Интеграция с микросервисами: Поддерживает service discovery для динамических окружений
 - Надежность: Может работать как standalone-система, не завися от внешних сервисов
 
Grafana:
 - Мощная визуализация: Поддерживает множество типов графиков и дашбордов
 - Гибкость: Позволяет создавать кастомные дашборды под конкретные нужды
 - Поддержка множества data sources: Кроме Prometheus, можно подключать другие источники данных

Оба инструмента open-source, большое сообщество, широкое распространение и множество готовых exporters и дашбордов.

# Задание *

```yaml
version: '3.8'

volumes:
  data:
  prometheus-data:
  grafana_data:
  elasticsearch_data:
  vector_data:

networks:
  app-network:
    driver: bridge
  monitoring-network:
    driver: bridge

services:
  # Существующие сервисы
  storage:
    image: minio/minio:latest
    command: server /data
    restart: always
    expose: 
      - 9000
    environment:
      MINIO_ROOT_USER: ${STORAGE_ACCESS_KEY:-minioadmin}
      MINIO_ROOT_PASSWORD: ${STORAGE_SECRET_KEY:-minioadmin}
      MINIO_PROMETHEUS_AUTH_TYPE: public
    volumes:
      - data:/data
    networks:
      - app-network
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    labels:
      - "log_collector=vector"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 10s      

  createbuckets:
    image: minio/mc
    depends_on:
      storage:
        condition: service_healthy
    restart: on-failure
    entrypoint: > 
      /bin/sh -c "      
      /usr/bin/mc alias set storage http://storage:9000 $${STORAGE_ACCESS_KEY:-minioadmin} $${STORAGE_SECRET_KEY:-minioadmin} &&
      /usr/bin/mc mb --ignore-existing storage/images &&
      /usr/bin/mc anonymous set download storage/images &&
      exit 0;
      "
    networks:
      - app-network

  uploader:
    build: ./uploader
    depends_on:
      - storage
      - createbuckets
    expose: 
      - 3000
    environment:
      PORT: 3000
      S3_HOST: storage
      S3_PORT: 9000
      S3_ACCESS_KEY: ${STORAGE_ACCESS_KEY:-minioadmin}
      S3_ACCESS_SECRET: ${STORAGE_SECRET_KEY:-minioadmin}
      S3_BUCKET: images
    networks:
      - app-network
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    labels:
      - "log_collector=vector"

  security:
    build: ./security
    expose: 
      - 3000
    environment:
      PORT: 3000
    networks:
      - app-network
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    labels:
      - "log_collector=vector"

  gateway:
    image: nginx:alpine
    volumes:
      - ./gateway/nginx.conf:/etc/nginx/nginx.conf:ro
    ports:
      - "80:8080"      
    depends_on:
      - storage
      - uploader
      - security
    networks:
      - app-network
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    labels:
      - "log_collector=vector"

  # Система сбора логов
  elasticsearch:
    image: elasticsearch:8.7.0
    container_name: es_hot
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
      - cluster.routing.allocation.disk.threshold_enabled=false
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
    networks:
      - monitoring-network
    ports:
      - "9200:9200"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://elasticsearch:9200/_cluster/health"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 40s

  kibana:
    image: kibana:8.7.0
    depends_on:
      elasticsearch:
        condition: service_healthy
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - ELASTICSEARCH_USERNAME=admin
      - ELASTICSEARCH_PASSWORD=qwerty123456
    networks:
      - monitoring-network
    ports:
      - "5601:5601"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5601/api/status"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 60s

  vector:
    image: timberio/vector:0.34.0-alpine
    depends_on:
      elasticsearch:
        condition: service_healthy
    volumes:
      - ./vector/vector.toml:/etc/vector/vector.toml:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /var/run/docker.sock:/var/run/docker.sock
      - vector_data:/var/lib/vector
    networks:
      - app-network
      - monitoring-network
    ports:
      - "8686:8686" # Vector internal metrics
    environment:
      - VECTOR_CONFIG=/etc/vector/vector.toml
    restart: unless-stopped
