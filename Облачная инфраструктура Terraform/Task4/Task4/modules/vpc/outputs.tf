output "network" {
  description = "Information about the created network"
  value       = yandex_vpc_network.this
}

output "subnets" {
  description = "Information about the created subnets"
  value       = yandex_vpc_subnet.subnets
}

output "subnet_ids" {
  description = "Map of zone to subnet ID"
  value       = { for s in yandex_vpc_subnet.subnets : s.zone => s.id }
}