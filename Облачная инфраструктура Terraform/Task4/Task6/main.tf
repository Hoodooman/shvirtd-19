# To always have a unique bucket name in this example
resource "random_string" "unique_id" {
  length  = 8
  upper   = false
  lower   = true
  numeric = true
  special = false
}

module "s3" {
  source = "git::https://github.com/terraform-yc-modules/terraform-yc-s3.git"

  bucket_name = "netology-bucket-${random_string.unique_id.result}"
  folder_id = var.folder_id
  versioning = {
    enabled = true
  }
}
