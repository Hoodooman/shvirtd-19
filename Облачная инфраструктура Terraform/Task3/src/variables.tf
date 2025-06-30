###cloud vars

variable "token" {
  type        = string
  default     = ""
  description = "yc iam create-token"
}

variable "cloud_id" {
  type        = string
  default     = "b1gqcs9kea3eqvm2uf3m"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1gbeq5mdvfdml5k7lv2"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "<your_ssh_ed25519_key>"
  description = "ssh-keygen -t ed25519"
}

variable "vms_ssh_public_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTghPVe1t4te9AHfljmlRAm1U57qQkFZLqfYhUG8q+a xrdpuser@popmatrix007.fvds.ru"
  description = "ssh-keygen -t ed25519"
}


variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    },
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 5
    }
  }
}

variable "storage_disks_count" {
  description = "Number of storage disks to create"
  type        = number
  default     = 3
}

variable "storage_name" {
  description = "Prefix for storage disk names"
  type        = string
  default     = "storage-disk"
}

variable "storage_disk_type" {
  description = "Type of storage disks"
  type        = string
  default     = "network-hdd"
}

variable "zone" {
  description = "Yandex Cloud zone"
  type        = string
  default     = "ru-central1-a"
}

variable "storage_disk_size" {
  description = "Size of storage disks in GB"
  type        = number
  default     = 1
}

variable "storage_instance_name" {
  description = "Name of the storage instance"
  type        = string
  default     = "storage"
}

variable "storage_platform_id" {
  description = "Platform ID for the storage instance"
  type        = string
  default     = "standard-v1"
}

variable "storage_instance_cores" {
  description = "Number of CPU cores for the storage instance"
  type        = number
  default     = 2
}

variable "storage_instance_memory" {
  description = "Amount of memory for the storage instance in GB"
  type        = number
  default     = 1
}

variable "storage_instance_core_fraction" {
  description = "Core fraction for the storage instance"
  type        = number
  default     = 5
}

variable "boot_disk_type" {
  description = "Type of boot disk"
  type        = string
  default     = "network-hdd"
}

variable "boot_disk_size" {
  description = "Size of boot disk in GB"
  type        = number
  default     = 5
}

variable "serial_port_enable" {
  description = "Enable serial port"
  type        = number
  default     = 1
}  

