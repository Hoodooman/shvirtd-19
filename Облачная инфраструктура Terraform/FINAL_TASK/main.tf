### vpc 
module "vpc" {
  source = "./modules/vpc"
  vpc_name      = "moex"
  default_zone  = var.default_zone
  default_cidr  = var.default_cidr
}


### mysql cluster
data "yandex_lockbox_secret" "db_credentials" {
  secret_id = var.lockbox_secret_id
}

data "yandex_lockbox_secret_version" "current" {
  secret_id = data.yandex_lockbox_secret.db_credentials.id
}

module "moex_cluster" {
  #source        = "./modules/terraform-yc-mysql"
  source        = "git::https://github.com/terraform-yc-modules/terraform-yc-mysql.git"
  name          = "moex"
  network_id    = module.vpc.network_id
  depends_on    = [module.vpc,yandex_vpc_security_group.moex_app]
  environment   = "PRESTABLE"
  description   = "Single-node MySQL cluster for test purposes"
  security_groups_ids_list = [yandex_vpc_security_group.moex_app.id]
  
  access_policy = {
    web_sql = true
  }

  performance_diagnostics = {
    enabled = true
  }

  hosts_definition = [
    {
      zone             = var.default_zone
      assign_public_ip = true
      subnet_id        = module.vpc.subnet_id
    }
  ]

  disk_size          = var.disk_size
  disk_type          = var.disk_type
  resource_preset_id = var.resource_preset_id
  

  mysql_config = {
    sql_mode                      = "ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
    innodb_print_all_deadlocks    = true    
    default_authentication_plugin = "MYSQL_NATIVE_PASSWORD"
    transaction_isolation         = "READ_COMMITTED"
    character_set_server          = "utf8"
    collation_server              = "utf8_unicode_ci"
  }

  databases = [{ "name" : "moex" }]

  users = [
    {
      name     = "trader"
      password = data.yandex_lockbox_secret_version.current.entries[0].text_value
      permissions = [
        {
          database_name = "moex"       # Applies to all databases
          roles         = ["ALL"]   # Grants full permissions
        }
      ]
    }
  ]
}

resource "null_resource" "create_stock_quotes_table" {
  depends_on = [module.moex_cluster]

  provisioner "local-exec" {
    command = <<EOT
      mysql --ssl-mode=REQUIRED \
        -h ${module.moex_cluster.cluster_fqdns_list[0][0]} \
        -u trader \
        -p"${data.yandex_lockbox_secret_version.current.entries[0].text_value}" \
        -e "CREATE TABLE IF NOT EXISTS moex.stock_quotes (
            ticker VARCHAR(10) NOT NULL,
            quote_time DATETIME NOT NULL,
            last_price DECIMAL(15,4) NOT NULL,
            price_change DECIMAL(15,4),
            currency CHAR(3),
            PRIMARY KEY (ticker, quote_time)
          );"
    EOT
  }
}

resource "null_resource" "generate_env" {
  depends_on = [module.moex_cluster]

  provisioner "local-exec" {
    command = <<-EOT
      echo "MYSQL_HOST=${try(module.moex_cluster.cluster_fqdns_list[0][0], null)}" > .env
      echo "MYSQL_PORT=3306" >> .env
      echo "MYSQL_USER=trader" >> .env
      echo "MYSQL_PASSWORD=${data.yandex_lockbox_secret_version.current.entries[0].text_value}" >> .env
      echo "MYSQL_DATABASE=${module.moex_cluster.databases[0]}" >> .env
    EOT
  }
}

resource "null_resource" "copy_mysql_env" {
  depends_on = [null_resource.generate_env, module.web_vm]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.sec_file)
    host        = module.web_vm.external_ip_address[0]
  }

  provisioner "file" {
    source      = ".env"
    destination = "/home/ubuntu/.env"
  }
}

### virtual machine

data "template_cloudinit_config" "app_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = yamlencode({
      users = [
        {
          name              = "ubuntu"
          groups            = "sudo"
          shell             = "/bin/bash"
          sudo              = "ALL=(ALL) NOPASSWD:ALL"
          ssh_authorized_keys = var.ssh_public_keys
        }
      ]
      package_update = true
      package_upgrade = true
      packages = [
        "apt-transport-https",
        "ca-certificates",
        "curl",
        "gnupg",
        "lsb-release"
      ]
    })
  }

part {
  content_type = "text/x-shellscript"
  content = <<-EOT
    #!/bin/bash
    set -e  # Exit on error
    set -x  # Print commands
    
    echo "Installing Docker..."
    sudo mkdir -p /etc/apt/keyrings/
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker ubuntu
    echo "Docker installed successfully"
  EOT
}

  # Часть 2: Создание Dockerfile
  part {
    content_type = "text/x-shellscript"
    content = <<-EOF
      #!/bin/bash
      cat << 'EOL' > /home/ubuntu/Dockerfile
      ${file("Dockerfile")}
      EOL
      chown ubuntu:ubuntu /home/ubuntu/Dockerfile
    EOF
  }

  # Часть 3: Создание docker-compose.yml
  part {
    content_type = "text/x-shellscript"
    content = <<-EOF
      #!/bin/bash
      cat << 'EOL' > /home/ubuntu/docker-compose.yml
      ${file("${path.module}/docker-compose.yml")}
      EOL
      chown ubuntu:ubuntu /home/ubuntu/docker-compose.yml
    EOF
  }

}

module "web_vm" {
  depends_on    = [module.moex_cluster, null_resource.generate_env]
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=09144db7f136b793064f1ac593fe2ac6921932f0"
  env_name       = "moex-app"
  network_id     = module.vpc.network_id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [module.vpc.subnet_id]
  instance_name  = "wm"
  instance_count = 1
  image_family   = var.image_family
  public_ip      = true
  labels = { 
    owner   = "alexz",
  }

  security_group_ids = [yandex_vpc_security_group.moex_app.id]

  metadata = {
    user-data          = data.template_cloudinit_config.app_config.rendered
    serial-port-enable = 1
  }
}

resource "null_resource" "run_docker_compose" {
  depends_on = [module.web_vm,null_resource.copy_mysql_env]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.sec_file)
    host        = module.web_vm.external_ip_address[0]
  }

  # Run docker-compose
  provisioner "remote-exec" {
    inline = [
      "timeout 180 bash -c 'until python3 -c \"import socket; socket.create_connection((\"127.0.0.1\", 5000))\" 2>/dev/null; do sleep 2; echo \"Ждём...\"; done && echo \"Сервис доступен!\"'", 
      "curl ifconfig.me",
      "echo '${var.token}' | sudo docker login --username iam --password-stdin cr.yandex",
      "cd /home/ubuntu && sudo docker compose up -d"
    ]
  }
}