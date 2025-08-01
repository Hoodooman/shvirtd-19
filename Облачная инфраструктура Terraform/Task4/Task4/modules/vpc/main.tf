locals {
  network_id = coalesce(var.existing_network_id, try(yandex_vpc_network.this[0].id, null))
}

resource "yandex_vpc_network" "this" {
  count = var.existing_network_id == null ? 1 : 0
  name  = var.env_name
}

resource "yandex_vpc_subnet" "subnets" {
  for_each = { for idx, subnet in var.subnets : idx => subnet }

  name           = "${var.env_name}-${each.value.zone}"
  zone           = each.value.zone
  network_id     =  local.network_id
  v4_cidr_blocks = [each.value.cidr]
}