output "subnet" {
  description = "Information about the created subnet"
  value       = yandex_vpc_subnet.public
}

output "network" {
  description = "Information about the created network"
  value       = yandex_vpc_network.this
}
