locals {
  project_name = "netology"
  environment  = "develop"
  vm_suffix    = "platform"
  role_web     = "web"
  role_db      = "db"

  vm_names = {
    web = "${local.project_name}-${local.environment}-${local.vm_suffix}-${local.role_web}",
    db  = "${local.project_name}-${local.environment}-${local.vm_suffix}-${local.role_db}"
  }
}