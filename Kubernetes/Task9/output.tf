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

# resource "local_file" "proxy_k8s_cluster" {
#    content = templatefile("${path.module}/ansible/templates/k8s_cluster.tftpl",
#      {
#       masters = yandex_compute_instance.masters[*]
#      }
#    )
#    filename = "${path.module}/ansible/inventory/k8s_cluster.yml"
# }

resource "local_file" "ssh_connect" {
   content = templatefile("${path.module}/ansible/templates/ssh_connect.tftpl",
     {
      masters = yandex_compute_instance.masters[*]
      jumpbox = yandex_compute_instance.jumpbox
     }
   )
   filename = "${path.module}/ansible/inventory/ssh_connect.ini"
}

resource "local_file" "control_plane" {
   content = templatefile("${path.module}/ansible/kubernetes-lb/templates/HA_cp_hosts.tftpl",
     {
      masters = yandex_compute_instance.masters[*]
     }
   )
   filename = "${path.module}/ansible/kubernetes-lb/hosts.ini"
}

# resource "local_file" "lg_group_all" {
#    content = templatefile("${path.module}/ansible/kubernetes-lb/templates/all.tftpl",
#      {
#       masters = yandex_compute_instance.masters[*]
#      }
#    )
#    filename = "${path.module}/ansible/kubernetes-lb/group_vars/all.yml"
# }