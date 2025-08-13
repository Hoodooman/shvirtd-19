###cloud vars

variable "token" {
  type        = string
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
  default     = ["10.1.0.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "moex-app"
  description = "VPC network&subnet name"
}

###ssh vars

variable "ssh_public_keys" {
  type        = list(string)
  default     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTghPVe1t4te9AHfljmlRAm1U57qQkFZLqfYhUG8q+a xrdpuser@popmatrix007.fvds.ru","ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGiVcfW8Wa/DxbBNzmQcwn7hJOj7ji9eoTpFakVnY/AI webinar","ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtPnfjgdy85DXfFCEQBTA9syvs906biuj9kkVL2mjm1E+MEz1HGF/6FMNdeeWyFc3ks2qyXVSl1lVuV54fcUbo88UyQUvoj9p5U1+Y3vV+Ed7z3XN7IkHzHmJjfDaEySBT0upGQTQ2VkTJUxqEqsbJN2oAxDEPd+ltF0ecDDPrWfsnmQPTBeiaE+XUKqPg3wR8Lu8Iy20/9pf6+qjHwvFUWmneRLT6xJghpru8P/MYILo3cq3uvcWb7umHwh9aMBz6D/KNgLifTz0abSb/JrHkPjLhCec4z35qxDe9Ocsubtd4J/X3fRsh7qNYJwLsGoEmvixZCPJ3tDn8g0j7Z2tONQXkRTCRgEP4hI3z6+5MtRWQZ6E+MuhOASpAom7Ql3tFvYWsNAp/KyvXydSob3bHBe3UjnbXCIl+T9z9+GgHfEsyw+B3wuy5LknOjBu5lhn3dREIyJYcVJORwOMFAKm8mRd6ceiRjlykGrppLj26yq+y4IzZJFUEpbRvJ0b/HVE="]
  description = "List of SSH public keys for VM access"
}

###lockbox

variable "lockbox_secret_id" {
  type        = string
  description = "ID секрета"
}

###mysql_cluster

variable "disk_size" {
  description = "Disk size for hosts"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "Disk type for hosts"
  type        = string
  default     = "network-hdd"
}

variable "resource_preset_id" {
  description = "Preset for hosts"
  type        = string
  default     = "b1.medium"
}

###web_vm

variable "image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "image"
}

variable "sec_file" {
  type        = string
  default     = "~/.ssh/shvirtd19_pvk"
  description = "private key"
}