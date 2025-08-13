terraform {
  required_version = ">= 1.3.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "> 0.9"
    }
    
  }


  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gqcs9kea3eqvm2uf3m/etnocbr0a9qjccbgn3pa"
    }

    shared_credentials_files = ["~/.aws/credentials"]

    bucket = "moex-app"
    region = "ru-central1"
    key    = "moex-app/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.

    dynamodb_table = "moex-app-state"
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}