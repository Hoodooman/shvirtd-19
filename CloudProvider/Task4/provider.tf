terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      # version = "= 0.168.0" # or another stable version
    }
  }


  # backend "s3" {
  #   endpoints = {
  #     s3 = "https://storage.yandexcloud.net"
  #     dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gqcs9kea3eqvm2uf3m/etnocbr0a9qjccbgn3pa"
  #   }

  #   shared_credentials_files = ["~/.aws/credentials"]

  #   # bucket = "popmatrix007"
  #   region = "ru-central1"

  #   skip_region_validation      = true
  #   skip_credentials_validation = true
  #   skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
  #   skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.
  # }

}

provider "aws" {
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}


provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = "ru-central1-a"
}