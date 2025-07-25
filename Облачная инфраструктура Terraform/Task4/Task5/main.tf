resource "yandex_vpc_network" "this" {
  name = "mysql-network"
}

module "mysql_cluster" {
  source      = "./modules/mysql_cluster"
  cluster_name = "example"
  network_id   = yandex_vpc_network.this.id
  ha           = true
}

module "mysql_db_user" {
  source      = "./modules/mysql_db_user"
  cluster_id  = module.mysql_cluster.cluster_id
  db_name     = "example_test_db"
  user_name   = "user"
}
