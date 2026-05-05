# Выводим информацию о network and subnet
output "subnet" {
  value = {
    network = module.vpc
    }
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