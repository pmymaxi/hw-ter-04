 # Выводим информацию о network and subnet
output "subnet" {
  value = {
    network = module.vpc
    }
}
 # Выводим информацию о vp
output "vpc_cloud_net" {
  value = var.vpc
}

# Выводим log файл вывода из yc console
output "yc_console" {
  value = data.local_file.cluster_info.content   
}

# Читаем log файл вывода из yc console
data "local_file" "cluster_info" {
  depends_on = [ null_resource.yc_console_cluster ]
  filename = "${path.module}/output.log"
}
# Формируем log файл вывода из yc console
resource "null_resource" "yc_console_cluster" {
  count = var.cluster_create ? 1 : 0 
  depends_on = [ module.mdb_mysql_cluster ]
  provisioner "local-exec" {
    command = <<EOT
    set -e
    { 
      echo "\n Cluster Info" 
      yc managed-mysql cluster list
      echo "Host list in cluster"
      yc managed-mysql host list --cluster-name=${module.mdb_mysql_cluster[0].cluster.name}
      echo "Databases info in cluster"
      yc managed-mysql database list --cluster-name=${module.mdb_mysql_cluster[0].cluster.name}
      echo "User name in databases cluster"
      yc managed-mysql user list --cluster-name=${module.mdb_mysql_cluster[0].cluster.name}
    } > output.log 2>&1
    EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

/*
#Считываем secret по path in vault для последующего вывода в output
data "vault_generic_secret" "vault_example"{
 path = "secret/example"
}

# Тест вывода пароля из vault
output "vault_example" {
 value = "${nonsensitive(data.vault_generic_secret.vault_example.data)}"
}

# создаем ресурс для отправки сприска паролей key=>value for json в vault
resource "vault_generic_secret" "example" {
  path = "secret/my-secret"

  data_json = <<EOT
{
  "bd":   "passdb",
  "user": "passuser"
}
EOT
}
*/