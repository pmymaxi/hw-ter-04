terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.12.0"
}


# Формируем кластер
resource "yandex_mdb_mysql_cluster" "clust-mysql-hw-04" {
  depends_on = [ yandex_vpc_security_group.mysql-sg ]
  name                = var.conf_cl.name
  environment         = var.conf_cl.environment
  network_id          = var.conf_cl.network_id 
  version             = var.conf_cl.version
  security_group_ids  = [ yandex_vpc_security_group.mysql-sg.id ]
  deletion_protection = var.conf_cl.deletion_protection # защита от удаления

#Вычислительные ресурсы хоста
  resources {
    resource_preset_id = var.conf_cl.resources.resource_preset_id # Класс хоста 
    disk_type_id       = var.conf_cl.resources.disk_type_id
    disk_size          = var.conf_cl.resources.disk_size
  }

/*Формируем хосты в кластере с использованием динамического блока, 
прилитать в объект будет больше одного хоста, variables list(object) 
так как dynamic ожидает только с list, map, toset*/

dynamic "host" {
  for_each = var.conf_cl.host
  content {
    zone             = host.value.zone
    subnet_id        = host.value.subnet_id 
    assign_public_ip = host.value.assign_public_ip
    backup_priority  = host.value.backup_priority # приоритет при выборе нового хоста-мастера: от 0 до 100.
    priority         = host.value.priority # приоритет для резервного копирования: от 0 до 100.
  }
}

}

# Создание БД
resource "yandex_mdb_mysql_database" "test_db" {
  depends_on = [ yandex_mdb_mysql_cluster.clust-mysql-hw-04 ]
  cluster_id = yandex_mdb_mysql_cluster.clust-mysql-hw-04.id # Добавляем в предварительно созданный кластер
  name       = var.conf_db.name
}
# Создание пользователя
resource "yandex_mdb_mysql_user" "userdb" {
  depends_on = [ yandex_mdb_mysql_database.test_db ]
  cluster_id = yandex_mdb_mysql_cluster.clust-mysql-hw-04.id # Добавляем в предварительно созданный кластер
  name       = var.conf_user.name
  password   = var.conf_user.password # Нужно передать безопасно
  permission {
    database_name = yandex_mdb_mysql_database.test_db.name # Приминение разрешения к предварительно созданной бд
    roles         = var.conf_user.roles # Права пользователя к БД
  }
}

# Формирование группы безопасности
resource "yandex_vpc_security_group" "mysql-sg" {
  name       = "mysql-sg"
  network_id = var.conf_cl.network_id

dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      protocol       = lookup(ingress.value, "protocol", null)
      description    = lookup(ingress.value, "description", null)
      port           = lookup(ingress.value, "port", null)
      from_port      = lookup(ingress.value, "from_port", null)
      to_port        = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks = lookup(ingress.value, "v4_cidr_blocks", null)
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      protocol       = lookup(egress.value, "protocol", null)
      description    = lookup(egress.value, "description", null)
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
      v4_cidr_blocks = lookup(egress.value, "v4_cidr_blocks", null)
    }
  }
}