```yaml
apiVersion: v1  # Версия API Kubernetes (для Pod всегда v1) 
kind: Pod       # Тип объекта Kubernetes 
metadata:       # Метаданные Pod 
  name: string  # Имя Pod (обязательное поле) 
  namespace: string # Namespace, в котором создается Pod h
  labels:       # Метки для идентификации и организации Pod 
    key: value
  annotations:  # Аннотации для хранения дополнительной информации (не для идентификации) 
    key: value
  generateName: string # Префикс для генерации уникального имени (используется вместо name)
  uid: string   # UID объекта (задается системой, неизменяем) 
  resourceVersion: string # Версия ресурса (задается системой)
  creationTimestamp: string # Время создания (задается системой) 
  deletionTimestamp: string # Время удаления (задается системой)
  finalizers:   # Финализаторы для контроля процесса удаления 
    - string
  ownerReferences: # Ссылки на владельцев объекта 
    - apiVersion: string
      kind: string
      name: string
      uid: string
      controller: boolean
      blockOwnerDeletion: boolean
spec:           # Спецификация Pod (желаемое состояние) 
  containers:   # Список контейнеров в Pod (обязательное поле) 
  - name: string # Имя контейнера (обязательное поле) 
    image: string # Образ контейнера (обязательное поле) 
    imagePullPolicy: Always | Never | IfNotPresent # Политика pull образа
    command: [string] # Команда, переопределяющая ENTRYPOINT
    args: [string]    # Аргументы, переопределяющие CMD
    workingDir: string # Рабочая директория
    ports:       # Публикуемые порты контейнера 
    - containerPort: int # Номер порта 
      protocol: TCP | UDP # Протокол (по умолчанию TCP)
      name: string       # Имя порта
      hostPort: int      # Порт на узле (если требуется)
      hostIP: string     # IP узла (если требуется)
    env:         # Переменные окружения :
    - name: string
      value: string
      valueFrom:        # Источник значения
        fieldRef:       # Ссылка на поле Pod
          fieldPath: string
        resourceFieldRef: # Ссылка на ресурс контейнера
          containerName: string
          resource: string
        configMapKeyRef: # Ссылка на ConfigMap
          name: string
          key: string
        secretKeyRef:    # Ссылка на Secret
          name: string
          key: string
    resources:   # Ресурсы контейнера (limits и requests) 
      limits:    # Максимальные ресурсы
        cpu: string
        memory: string
        ephemeral-storage: string
        hugepages-<size>: string
      requests:  # Запрашиваемые ресурсы
        cpu: string
        memory: string
        ephemeral-storage: string
        hugepages-<size>: string
    volumeMounts: # Точки монтирования томов :
    - name: string # Имя тома
      mountPath: string # Путь монтирования
      readOnly: boolean
      subPath: string # Подпуть в томе
      subPathExpr: string # Выражение для подпути
    livenessProbe: # Проверка жизнеспособности
      exec:        # Выполнение команды
        command: [string]
      httpGet:     # HTTP запрос
        path: string
        port: int
        host: string
        scheme: string
        httpHeaders:
        - name: string
          value: string
      tcpSocket:   # TCP подключение
        port: int
        host: string
      initialDelaySeconds: int # Задержка перед первой проверкой
      periodSeconds: int       # Периодичность проверок
      timeoutSeconds: int      # Таймаут проверки
      successThreshold: int    # Порог успешных проверок
      failureThreshold: int    # Порог неудачных проверок
    readinessProbe: # Проверка готовности (аналогично livenessProbe)
    startupProbe:   # Проверка старта (аналогично livenessProbe)
    lifecycle:      # Хуки жизненного цикла
      postStart:    # Хук после старта (аналогично livenessProbe)
      preStop:      # Хук перед остановкой (аналогично livenessProbe)
    terminationMessagePath: string # Путь к файлу с сообщением о завершении
    terminationMessagePolicy: File | FallbackToLogsOnError
    securityContext: # Контекст безопасности контейнера
      privileged: boolean
      runAsUser: int
      runAsGroup: int
      runAsNonRoot: boolean
      readOnlyRootFilesystem: boolean
      allowPrivilegeEscalation: boolean
      capabilities:
        add: [string]
        drop: [string]
      procMount: string
      seLinuxOptions:
        level: string
        role: string
        type: string
        user: string
      windowsOptions:
        gmsaCredentialSpecName: string
        gmsaCredentialSpec: string
        runAsUserName: string
    stdin: boolean    # Открытие STDIN
    stdinOnce: boolean # Закрытие STDIN после первого подключения
    tty: boolean      # Выделение TTY
  initContainers:     # Init контейнеры (запускаются до основных) 
  - ...               # (Те же поля, что и для containers)
  ephemeralContainers: # Эфемерные контейнеры для отладки 
  - ...               # (Те же поля, что и для containers)
  restartPolicy: Always | OnFailure | Never # Политика перезапуска 
  terminationGracePeriodSeconds: int # Время на корректное завершение
  activeDeadlineSeconds: int        # Максимальное время работы Pod
  dnsPolicy: Default | ClusterFirst | ClusterFirstWithHostNet | None
  nodeSelector:        # Селектор узлов 
    key: value
  serviceAccountName: string # Имя ServiceAccount
  automountServiceAccountToken: boolean
  nodeName: string     # Имя узла для размещения Pod
  hostNetwork: boolean # Использование сетевого пространства узла
  hostPID: boolean     # Использование PID пространства узла
  hostIPC: boolean     # Использование IPC пространства узла
  shareProcessNamespace: boolean # Совместное использование пространства процессов между контейнерами
  securityContext:     # Контекст безопасности на уровне Pod
    runAsUser: int
    runAsGroup: int
    runAsNonRoot: boolean
    supplementalGroups: [int]
    fsGroup: int
    fsGroupChangePolicy: OnRootMismatch | Always
    seLinuxOptions:
      level: string
      role: string
      type: string
      user: string
    windowsOptions:
      gmsaCredentialSpecName: string
      gmsaCredentialSpec: string
      runAsUserName: string
    sysctls:           # Настройки sysctl
    - name: string
      value: string
  imagePullSecrets:   # Секреты для pull образов 
  - name: string
  hostname: string    # Hostname Pod
  subdomain: string   # Subdomain Pod
  affinity:           # Аффинити Pod
    nodeAffinity:     # Аффинити к узлам
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: string
            operator: In | NotIn | Exists | DoesNotExist | Gt | Lt
            values: [string]
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: int
        preference:
          matchExpressions:
          - key: string
            operator: In | NotIn | Exists | DoesNotExist | Gt | Lt
            values: [string]
    podAffinity:      # Аффинити к другим Pod
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: string
            operator: In | NotIn | Exists | DoesNotExist | Gt | Lt
            values: [string]
        namespaces: [string]
        topologyKey: string
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: int
        podAffinityTerm:
          labelSelector:
            matchExpressions:
            - key: string
              operator: In | NotIn | Exists | DoesNotExist | Gt | Lt
              values: [string]
          namespaces: [string]
          topologyKey: string
    podAntiAffinity:  # Анти-аффинити к другим Pod (аналогично podAffinity)
  tolerations:        # Толерации для узлов с taints 
  - key: string
    operator: Equal | Exists
    value: string
    effect: NoSchedule | PreferNoSchedule | NoExecute
    tolerationSeconds: int
  priorityClassName: string # Класс приоритета Pod
  priority: int      # Приоритет Pod
  preemptionPolicy: Never | PreemptLowerPriority
  topologySpreadConstraints: # Ограничения распределения по топологии
  - maxSkew: int
    topologyKey: string
    whenUnsatisfiable: DoNotSchedule | ScheduleAnyway
    labelSelector:
      matchLabels:
        key: value
      matchExpressions:
      - key: string
        operator: In | NotIn | Exists | DoesNotExist
        values: [string]
  runtimeClassName: string # Класс runtime
  overhead:         # Ресурсные overhead
    cpu: string
    memory: string
    ephemeral-storage: string
  schedulerName: string    # Имя планировщика
  enableServiceLinks: boolean
  setHostnameAsFQDN: boolean
  os:              # Настройки ОС 
    name: linux | windows # ОС (linux или windows) 
  hostUsers: boolean # Монтирование /etc/passwd узла
  volumes:         # Тома Pod :
  - name: string   # Имя тома (обязательное поле)
    emptyDir:      # Пустой временный том
      medium: "" | Memory
      sizeLimit: string
    hostPath:      # Том из пути на узле
      path: string
      type: Directory | DirectoryOrCreate | File | FileOrCreate | Socket | CharDevice | BlockDevice
    secret:        # Том из Secret
      secretName: string
      items:
      - key: string
        path: string
        mode: int
      defaultMode: int
      optional: boolean
    configMap:     # Том из ConfigMap
      name: string
      items:
      - key: string
        path: string
        mode: int
      defaultMode: int
      optional: boolean
    persistentVolumeClaim: # Том из PVC
      claimName: string
      readOnly: boolean
    downwardAPI:   # Том downward API
      items:
      - path: string
        fieldRef:
          fieldPath: string
        resourceFieldRef:
          containerName: string
          resource: string
        mode: int
      defaultMode: int
    projected:     # Проецируемый том
      sources:
      - secret:
          name: string
          items:
          - key: string
            path: string
            mode: int
      - configMap:
          name: string
          items:
          - key: string
            path: string
            mode: int
      - downwardAPI:
          items:
          - path: string
            fieldRef:
              fieldPath: string
            resourceFieldRef:
              containerName: string
              resource: string
            mode: int
      - serviceAccountToken:
          audience: string
          expirationSeconds: int
          path: string
      defaultMode: int
    csi:           # Том CSI (Container Storage Interface)
      driver: string
      volumeAttributes:
        key: value
      readOnly: boolean
    awsElasticBlockStore: # Том AWS EBS (устаревший, использовать CSI)
      volumeID: string
      fsType: string
      readOnly: boolean
    azureDisk:     # Том Azure Disk (устаревший, использовать CSI)
      diskName: string
      diskURI: string
      kind: Shared | Dedicated | Managed
      cachingMode: None | ReadOnly | ReadWrite
      fsType: string
      readOnly: boolean
    azureFile:     # Том Azure File (устаревший, использовать CSI)
      secretName: string
      shareName: string
      readOnly: boolean
    gcePersistentDisk: # Том GCE Persistent Disk (устаревший, использовать CSI)
      pdName: string
      fsType: string
      readOnly: boolean
    ... # Другие типы томов
status:           # Текущее состояние Pod (заполняется системой) 
  phase: Pending | Running | Succeeded | Failed | Unknown
  conditions:     # Состояния Pod
  - type: Ready | ContainersReady | PodScheduled | Initialized
    status: True | False | Unknown
    lastProbeTime: string
    lastTransitionTime: string
    reason: string
    message: string
  message: string
  reason: string
  hostIP: string
  podIP: string
  podIPs:
  - ip: string
  startTime: string
  containerStatuses: # Статусы контейнеров
  - name: string
    state:          # Текущее состояние контейнера
      waiting:
        reason: string
        message: string
      running:
        startedAt: string
      terminated:
        exitCode: int
        signal: int
        reason: string
        message: string
        startedAt: string
        finishedAt: string
    lastState:      # Предыдущее состояние контейнера (аналогично state)
    ready: boolean
    restartCount: int
    image: string
    imageID: string
    containerID: string
  qosClass: Burstable | Guaranteed | BestEffort
  ephemeralContainerStatuses: # Статусы эфемерных контейнеров
  - ... # (Аналогично containerStatuses)
```
# Ключевые замечания:
- Обязательные поля: Только apiVersion, kind, metadata.name и spec.containers строго обязательны для создания Pod. Остальные поля опциональны .

- Динамические поля: Секция status управляется Kubernetes и не должна указываться при создании Pod .

- Версии API: Для Pod всегда используется apiVersion: v1 .

- Расширенные возможности: Некоторые поля (например, affinity, toleration) требуют понимания продвинутых концепций Kubernetes .

- Безопасность: Контекст безопасности (securityContext) можно задавать как на уровне Pod, так и на уровне контейнера
