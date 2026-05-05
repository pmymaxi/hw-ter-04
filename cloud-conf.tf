# Строим ХЭШ пароля для passwd, не луший вариант, но только как для теста
resource "null_resource" "gen_passwd" {
  provisioner "local-exec" {
    command    = <<EOT
    openssl passwd -6 -stdin < ${abspath(path.module)}/passwd.gen > ${abspath(path.module)}/passwd.key
     EOT
    on_failure = continue
  }
}

# Читаем файл cloud-init.yml, формируем на основе переменных
data "template_file" "metadata" {
  depends_on = [null_resource.gen_passwd]

  template = file("${path.module}/cloud-init.yml")
  vars = {
    name       = var.vm_module.marketing.cloud_init.users.name
    groups     = var.vm_module.marketing.cloud_init.users.groups
    passwd     = file("passwd.key") # cloud init ждёт ХЭШ пароля, а не текст
    ssh_public = local.vms_ssh_public_root_key
  }
}


