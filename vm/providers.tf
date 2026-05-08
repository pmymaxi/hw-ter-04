terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.12.0"
}

provider "yandex" {
  #token     = var.token
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
  service_account_key_file = file("~/.ssh/sa_key_yc.json")
}

provider "vault" {
 address = "http://127.0.0.1:8200"
 skip_tls_verify = true
 token = var.VAULT_TOKEN
}
