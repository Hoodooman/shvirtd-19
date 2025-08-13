data "yandex_lockbox_secret" "db_credentials" {
  secret_id = var.lockbox_secret_id
}

data "yandex_lockbox_secret_version" "current" {
  secret_id = data.yandex_lockbox_secret.db_credentials.id
}

module "vpc" {
  source = "./modules/vpc"
  vpc_name      = "moex"
  default_zone  = var.default_zone
  default_cidr  = var.default_cidr
}

module "moex_cluster" {
  source        = "./modules/terraform-yc-mysql"
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

module "web_vm" {
  source        = "./modules/vm"
  env_name      = "moex-app"
  instance_name = "wm"
  owner         = "alexz"
  network_id    = module.vpc.network_id
  subnet_id     = module.vpc.subnet_id
  sec_group     = yandex_vpc_security_group.moex_app.id
  depends_on    = [module.vpc,yandex_vpc_security_group.moex_app,module.moex_cluster]
  token         = var.token
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
  depends_on = [null_resource.generate_env]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.sec_file)
    host        = module.web_vm.public_ip
  }

  provisioner "file" {
    source      = ".env"
    destination = "/home/ubuntu/.env"
  }
}

resource "null_resource" "copy_mysql_dockerfile" {
  depends_on = [null_resource.generate_env]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.sec_file)
    host        = module.web_vm.public_ip
  }

  provisioner "file" {
    source      = "Dockerfile"
    destination = "/home/ubuntu/Dockerfile"
  }
}

resource "null_resource" "copy_docker_compose" {
  depends_on = [module.web_vm]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.sec_file)
    host        = module.web_vm.public_ip
  }

  provisioner "file" {
    source      = "${path.module}/docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml"
  }
}

resource "null_resource" "run_docker_compose" {
  depends_on = [module.web_vm,resource.null_resource.copy_docker_compose,resource.null_resource.copy_mysql_dockerfile]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.sec_file)
    host        = module.web_vm.public_ip
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
