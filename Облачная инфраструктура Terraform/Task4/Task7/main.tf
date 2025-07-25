provider "vault" {
  address         = "http://127.0.0.1:8200"
  skip_tls_verify = true
  token           = "education"
}

data "vault_generic_secret" "vault_example" {
  path = "secret/example"
}

output "vault_example" {
  value = nonsensitive(data.vault_generic_secret.vault_example.data)
}

output "test_value" {
  value = nonsensitive(data.vault_generic_secret.vault_example.data["test"])
}

resource "vault_generic_secret" "new_secret" {
  path = "secret/terraform"

  data_json = jsonencode({
    test_terraform = "terraform_created"
  })
}

output "new_secret" {
  value = nonsensitive(vault_generic_secret.new_secret.data)
}