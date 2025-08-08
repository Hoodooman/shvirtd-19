output "mysql_cluster_id" {
  description = "MySQL cluster ID"
  value       = try(module.moex_cluster.cluster_id, null)
}

output "mysql_cluster_name" {
  description = "MySQL cluster name"
  value       = try(module.moex_cluster.cluster_name, null)
}

output "mysql_cluster_host_names_list" {
  description = "MySQL cluster host name list"
  value       = try(module.moex_cluster.cluster_host_names_list, null)
}

output "mysql_cluster_fqdns_list" {
  description = "MySQL cluster FQDNs list"
  value       = try(module.moex_cluster.cluster_fqdns_list, null)
}

output "db_owners" {
  description = "A list of DB owners users with password."
  value       = try(module.moex_cluster.owners_data, null)
}

output "db_users" {
  sensitive   = true
  description = "A list of separate DB users with passwords."
  value       = try(module.moex_cluster.users_data, null)
}

output "mysql_databases" {
  description = "A list of database names."
  value       = try(module.moex_cluster.databases, null)
}

output "lockbox" {
  value       = try(var.lockbox_secret_id,null)
}

output "FQDN" {
  description = "FQDN"
  value       = try(module.moex_cluster.cluster_fqdns_list[0][0], null)
}

output "vm_ip" {
  description = "ip"
  value       = try(module.web_vm.public_ip, null)
}