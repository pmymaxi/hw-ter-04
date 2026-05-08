# Читаем файл cloud-init.yml, формируем на основе переменных
data "template_file" "metadata" {
  depends_on = [data.external.passwd_hash]

  template = file("${path.module}/cloud-init.yml")
  vars = {
    name       = var.vm_module.marketing.cloud_init.users.name
    groups     = var.vm_module.marketing.cloud_init.users.groups
    passwd     = local.passhash
    ssh_public = local.vms_ssh_public_root_key
  }
}
# Читаем secret path из VAULT
data "vault_generic_secret" "pass_vm" {
  path = "secret/sec-hw-terraform"
}
# Создаем локальную переменную metadata vm и hash пароля
locals {
  passwd = data.vault_generic_secret.pass_vm.data["vm"]
  passhash = data.external.passwd_hash.result.passhash
}

/* Формируем hash полученного пароля из VAULT, обязательно возвращать в Json,
external data source в Terraform строго требует JSON-формат на выходе
*/
data "external" "passwd_hash" {
  depends_on = [ data.vault_generic_secret.pass_vm ]
  program = ["bash", "-c", <<EOT
  passhash=$(openssl passwd -6 "${local.passwd}")
  echo "{\"passhash\":\"$passhash\"}"
EOT
  ]
}

/* Метод с файлом
# Строим HASH пароля для passwd, чтобы при выводе не светился пароль а передовался HASH
resource "null_resource" "gen_passwd" {
  provisioner "local-exec" {
    command    = <<EOT
    echo "${local.passwd}" | openssl passwd -6 -stdin > ${abspath(path.module)}/passwd.key
     EOT
    on_failure = continue
  }
}
*/