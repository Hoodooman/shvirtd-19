locals {
  webservers = try(
    [for vm in yandex_compute_instance.web_vms[*] : {
      name       = vm.name
      ip_address = vm.network_interface[0].ip_address
      fqdn       = try(vm.fqdn, null)
    }],
    try(
      [for vm in values(yandex_compute_instance.web_vms) : {
        name       = vm.name
        ip_address = vm.network_interface[0].ip_address
        fqdn       = try(vm.fqdn, null)
      }],
      []
    )
  )

  databases = try(
    [for vm in yandex_compute_instance.db_vms[*] : {
      name       = vm.name
      ip_address = vm.network_interface[0].ip_address
      fqdn       = try(vm.fqdn, null)
    }],
    try(
      [for vm in values(yandex_compute_instance.db_vms) : {
        name       = vm.name
        ip_address = vm.network_interface[0].ip_address
        fqdn       = try(vm.fqdn, null)
      }],
      []
    )
  )
  
  storages = try(
    [for vm in yandex_compute_instance.storage[*] : {
      name       = vm.name
      ip_address = vm.network_interface[0].ip_address
      fqdn       = try(vm.fqdn, null)
    }],
    try(
      [for vm in values(yandex_compute_instance.storage) : {
        name       = vm.name
        ip_address = vm.network_interface[0].ip_address
        fqdn       = try(vm.fqdn, null)
      }],
      []
    )
  )
}


resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tftpl", {
    webservers = local.webservers
    databases = local.databases
    storage = local.storages
  })
  filename = "${path.module}/inventory.ini"
}
