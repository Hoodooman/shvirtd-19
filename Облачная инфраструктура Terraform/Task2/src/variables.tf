###cloud vars


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
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTghPVe1t4te9AHfljmlRAm1U57qQkFZLqfYhUG8q+a xrdpuser@popmatrix007.fvds.ru"
  description = "ssh-keygen -t ed25519"
}

variable "vms_ssh_public_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTghPVe1t4te9AHfljmlRAm1U57qQkFZLqfYhUG8q+a xrdpuser@popmatrix007.fvds.ru"
  description = "ssh-keygen -t ed25519"
}

variable "token" {
  type        = string
  default     = "t1.9euelZqczJ2SjcePnoucz82XkcuXj-3rnpWakpXMyZDKks3Ol5qTncfJz83l8_dmRDE9-e9DGwFG_t3z9yZzLj3570MbAUb-zef1656VmsvMyJSanpiPi4_KzcjNyZTO7_zF656VmsvMyJSanpiPi4_KzcjNyZTO.g1NTYBwnHT2GXu310xAf88CrqT5gb-MIYcR63joBr4eZgTDt4G3aGkGMZPk82TphQdCQV8mqVzd0La2UU_orBA"
  description = "IAM token 12 hours lifecycle"
}


variable "test" {
  description = "List of lists"

  type = list(
    map(
      list(string)
    )
  )
}