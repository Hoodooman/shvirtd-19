module "vpc" {
  source = "github.com/terraform-yc-modules/terraform-yc-vpc"

  network_name = "cluster-net"
  create_vpc          = true

  public_subnets = [
    {
      "v4_cidr_blocks" : ["10.121.0.0/16"],
      "zone" : "ru-central1-a"
    },
    {
      "v4_cidr_blocks" : ["10.131.0.0/16"],
      "zone" : "ru-central1-b"
    },
    {
      "v4_cidr_blocks" : ["10.141.0.0/16"],
      "zone" : "ru-central1-d"
    },
  ]
  private_subnets = [
    {
      "v4_cidr_blocks" : ["10.221.0.0/16"],
      "zone" : "ru-central1-a"
    },
    {
      "v4_cidr_blocks" : ["10.231.0.0/16"],
      "zone" : "ru-central1-b"
    },
    {
      "v4_cidr_blocks" : ["10.241.0.0/16"],
      "zone" : "ru-central1-d"
    },
  ]
}

module "moex_cluster" {
  source        = "github.com/terraform-yc-modules/terraform-yc-mysql"
  depends_on    = [module.vpc]
    
  network_id    = module.vpc.vpc_id
  description              = "Multi-node MySQL cluster for test purposes"

  name    = "netology-mysql"
  environment     = "PRESTABLE"
  
  
  # Конфигурация хостов для отказоустойчивости across AZ
  hosts_definition = [
    {
      name      = "first"
      zone      = "ru-central1-a"
      subnet_id = module.vpc.private_subnets["10.221.0.0/16"].subnet_id
    },
    {
      name      = "second"
      zone      = "ru-central1-b"
      subnet_id = module.vpc.private_subnets["10.231.0.0/16"].subnet_id     
    },
    {
      name      = "sec_replica"
      zone      = "ru-central1-b"
      subnet_id = module.vpc.private_subnets["10.231.0.0/16"].subnet_id 
      replication_source_name = "second"
    }
  ]

  mysql_config = {
    sql_mode                      = "ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
    max_connections               = 100
    default_authentication_plugin = "MYSQL_NATIVE_PASSWORD"
  }

# Параметры ресурсов
  resource_preset_id = "b1.medium" # Intel Broadwell, 50% CPU

  access_policy = {
    web_sql = false
  }

  performance_diagnostics = {
    enabled = false
  }

  # Базы данных
  databases = [
    {
      name = "netology_db"
    }
  ]

  # Пользователи
  users = [
    {
      # name     = "netology"
      # password = "netology" # Замените на надежный пароль
      # permissions = [
      #   {
      #     database_name = "netology_db"
      #     roles         = ["ALL"]
      #   }
      # ]

      name     = "netology"
      password = "dbPassw0rd"

      permission = [
        {
          roles = ["ALL"]
        }
      ]

      connection_limits = {
      max_questions_per_hour = 1000
      max_updates_per_hour = 2000
      max_connections_per_hour = 3000
      max_user_connections     = 4000
      }

      global_permissions = ["PROCESS"]
      authentication_plugin = "MYSQL_NATIVE_PASSWORD"      
    }
  ]

  # Политика технического обслуживания
  maintenance_window = {
    type = "ANYTIME" # Произвольное время технического обслуживания
  }

  # Политика резервного копирования
  backup_window_start = {
    hours   = 23
    minutes = 59
  }

  # Защита от удаления
  deletion_protection = false
}


################################################################
######################## k8s cluster ###########################

module "k8s" {
  source = "github.com/terraform-yc-modules/terraform-yc-kubernetes"
  network_id = module.vpc.vpc_id

  master_locations = [
    {
      zone      = "ru-central1-a"
      subnet_id = module.vpc.public_subnets["10.121.0.0/16"].subnet_id
    },
    {
      zone      = "ru-central1-b"
      subnet_id = module.vpc.public_subnets["10.131.0.0/16"].subnet_id
    },
    {
      zone      = "ru-central1-d"
      subnet_id = module.vpc.public_subnets["10.141.0.0/16"].subnet_id
    }
  ]

  release_channel = "STABLE"

  node_groups = {
    "yc-k8s-ng-01" = {
      description = "Kubernetes nodes group 01"
      auto_scale = {
        min     = 1
        max     = 3
        initial = 1
      }
      labels = {
        owner   = "example"
        service = "kubernetes"
      }
      node_labels = {
        role        = "worker-01"
        environment = "testing"
      }
    }
  }

  # Custom ingress /egress rules
  custom_ingress_rules = {
    "rule1" = {
      protocol       = "ANY"
      description    = "rule-1"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 0
      to_port        = 65535
    }
  }

  custom_egress_rules = {
    "rule1" = {
      protocol       = "ANY"
      description    = "rule-1"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 0
      to_port        = 65535
    }
  }  
}

output "kubectl_ext" {
  value = module.k8s.external_cluster_cmd
}

