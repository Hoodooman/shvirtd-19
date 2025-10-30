// Create SA
resource "yandex_iam_service_account" "sa" {
  folder_id = var.yc_folder_id
  name      = "cloudhw-sa"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.yc_folder_id
  # role      = "editor"
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-storage-editor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor" // This role allows bucket creation and management
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor-encrypter-decrypter" {
  folder_id = var.yc_folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

locals {
  bucket_name = "cloudhw.com"
}

// Use keys to create bucket

resource "yandex_storage_bucket_grant" "public_read" {
  depends_on = [yandex_storage_bucket.s3-bucket]
  bucket = yandex_storage_bucket.s3-bucket.id
  grant {
    uri         = "http://acs.amazonaws.com/groups/global/AuthenticatedUsers"
    permissions = ["READ"]
    type        = "Group"
  }
}

resource "yandex_kms_symmetric_key" "secret-key" {
  name              = "kms"
  description       = "ключ для шифрования бакета"
  default_algorithm = "AES_128"
  rotation_period   = "24h"
}

resource "yandex_storage_bucket" "s3-bucket" {
  depends_on = [yandex_resourcemanager_folder_iam_member.sa-storage-editor,yandex_kms_symmetric_key.secret-key]
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.bucket_name
  force_destroy = true
  website {
    index_document = "ironmaiden.jpg"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.secret-key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle {
    prevent_destroy = false
  }

  anonymous_access_flags {
    read        = true
    list        = true
    config_read = true
  }
}

resource "yandex_storage_object" "load_pict" {
  depends_on = [yandex_storage_bucket.s3-bucket]
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key  
  bucket = local.bucket_name
  key    = "ironmaiden.jpg"
  source = "./images/ironmaiden.jpg"
}