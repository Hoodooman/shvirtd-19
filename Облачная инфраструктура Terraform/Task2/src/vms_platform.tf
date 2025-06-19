variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "ubuntu image"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "server name"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "platform id"
}

/*
variable "vm_web_core" {
  type        = number
  default     = 2
  description = "Core used"
}

variable "vm_web_memory" {
  type        = number
  default     = 1
  description = "Memory used"
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 5
  description = "Percent core used"
}
*/


variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "second vm name"
}

variable "vm_db_vpc_name" {
  type        = string
  default     = "develop-b"
  description = "zone-b VPC network & subnet name"
}

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "second vm zone"
}

variable "vm_db_cidr" {
  type        = list(string)
  default     = ["10.129.0.0/24"]
  description = "default-ru-central1-b"
}

/*
variable "vm_db_core" {
  type        = number
  default     = 2
  description = "Core used"
}

variable "vm_db_memory" {
  type        = number
  default     = 2
  description = "Memory used"
}

variable "vm_db_core_fraction" {
  type        = number
  default     = 20
  description = "Percent core used"
}
*/

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
      core_fraction = 20
    }
  }
}


variable "metadata" {
  type = map(string)
  default = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTghPVe1t4te9AHfljmlRAm1U57qQkFZLqfYhUG8q+a xrdpuser@popmatrix007.fvds.ru"
  }
  description = "Common metadata for all VMs"
}