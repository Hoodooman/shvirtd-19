resource "local_file" "test_1" {
  content =  <<-EOT
  %{if length(yandex_compute_instance.web_vms) > 0}
  [webservers]
  %{for i in yandex_compute_instance.web_vms }
    ${i["name"]}   ansible_host=${i["network_interface"][0]["ip_address"]}
  %{endfor}
  %{endif}
  EOT
  filename = "${abspath(path.module)}/test_1.ini"
}
