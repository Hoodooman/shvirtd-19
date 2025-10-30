# variables.tf
variable "yc_folder_id" {
  type        = string
  default     = "b1gbeq5mdvfdml5k7lv2"
  description = "Yandex Cloud folder ID"
}

variable "yc_cloud_id" {
  type        = string
  default     = "b1gqcs9kea3eqvm2uf3m"
  description = "Yandex Cloud cloud ID"
}

variable "yc_token" {
  type        = string
  description = "Yandex Cloud OAuth token"
  sensitive   = true
}

variable "homedir" {
  type        = string
  default     = "/home/ubuntu"
  description = "User $HOMEDIR"
}

variable "pvk" {
  type        = string
  default     = "shvirtd-19_pvk"
  description = "private key name"
  sensitive   = true
}

variable "ssh_public_keys" {
  type        = list(string)
  default     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTghPVe1t4te9AHfljmlRAm1U57qQkFZLqfYhUG8q+a xrdpuser@popmatrix007.fvds.ru"]
  description = "List of SSH public keys for VM access"
}
