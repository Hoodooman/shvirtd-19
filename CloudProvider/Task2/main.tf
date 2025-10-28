// Create SA
resource "yandex_iam_service_account" "sa" {
  folder_id = var.yc_folder_id
  name      = "cloudhw-sa"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.yc_folder_id
  # role      = "editor"
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-storage-editor" {
  folder_id = var.yc_folder_id
  role      = "editor" // This role allows bucket creation and management
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

locals {
  bucket_name = "cloud-task2-${formatdate("YYYYMMDD", timestamp())}"
}

// Use keys to create bucket

resource "yandex_storage_bucket_grant" "public_read" {
  depends_on = [yandex_storage_bucket.s3-bucket]
  bucket = yandex_storage_bucket.s3-bucket.id
  grant {
    uri         = "http://acs.amazonaws.com/groups/global/AuthenticatedUsers"
    permissions = ["READ"]
    type        = "Group"
  }
}

resource "yandex_storage_bucket" "s3-bucket" {
  depends_on = [yandex_resourcemanager_folder_iam_member.sa-storage-editor]
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.bucket_name
  force_destroy = true
  website {
    index_document = "ironmaiden.jpg"
  }

  anonymous_access_flags {
    read        = true
    list        = true
    config_read = true
  }
}

resource "yandex_storage_object" "load_pict" {
  depends_on = [yandex_storage_bucket.s3-bucket]
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key  
  bucket = local.bucket_name
  key    = "ironmaiden.jpg"
  source = "./images/ironmaiden.jpg"
}

resource "yandex_compute_instance_group" "group1" {
  name                = "lamp-vw"
  folder_id           = var.yc_folder_id
  service_account_id  = yandex_iam_service_account.sa.id
  deletion_protection = false

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
    ]
  }

  instance_template {
    platform_id = "standard-v3"
    resources {
      core_fraction = 20
      memory        = 2
      cores         = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 10
      }
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      network_id = yandex_vpc_network.yc-network.id
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      nat        = true
    }
    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/shvirtd-19_pvk.pub")}"
      user-data  = <<EOF
#!/bin/bash
# Получаем приватный и публичный IP адреса
PRIVATE_IP=$(hostname -I | awk '{print $1}')
PUBLIC_IP=$(curl -s ifconfig.me)

# Создаем HTML страницу с информацией об IP адресах
cat > /var/www/html/index.html << EOL
<!DOCTYPE html>
<html>
<head>
    <title>Instance Information</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .info { background-color: #f5f5f5; padding: 20px; border-radius: 5px; }
        .ip-address { color: #2c3e50; font-weight: bold; }
    </style>
</head>
<body>
    <h1>Instance Information</h1>
    <div class="info">
        <p><strong>Hostname:</strong> $(hostname)</p>
        <p><strong>Private IP:</strong> <span class="ip-address">$PRIVATE_IP</span></p>
        <p><strong>Public IP:</strong> <span class="ip-address">$PUBLIC_IP</span></p>
    </div>
    <div>
        <h2>Image from Storage</h2>
        <img src="https://${yandex_storage_bucket.s3-bucket.website_endpoint}">
    </div>
</body>
</html>
EOL
EOF 
    }
    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 3
    max_creating    = 3
    max_expansion   = 3
    max_deleting    = 3
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "Целевая группа Network Load Balancer"
  }

}

resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "network-load-balancer-1"
  depends_on = [yandex_compute_instance_group.group1]
  listener {
    name = "network-load-balancer-1-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.group1.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}


output "lamp_vm" {
  value = yandex_compute_instance_group.group1[*]
}

output "lb" {
  value = yandex_lb_network_load_balancer.lb-1.listener
}
