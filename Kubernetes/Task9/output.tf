# Генерация Ansible inventory файла kubespray
resource "local_file" "ansible_kubespray" {
  content = templatefile("${path.module}/ansible/templates/hosts.tftpl",
    {
      # Pass the entire instance objects, not just IPs
      workers = yandex_compute_instance.workers[*]
      masters = yandex_compute_instance.masters[*]
    }
  )
  filename = "${path.module}/ansible/inventory/hosts.yaml"
}

