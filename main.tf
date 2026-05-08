/*
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}
*/
/*
module "vpc_prod" {
  source       = "./vpc"
  vpc_sub_name = var.vpc.vpc_prod.vpc_sub_name
  subnets      = var.vpc.vpc_prod.subnets
}
module "vpc_dev" {
  source       = "./vpc"
  vpc_sub_name = var.vpc.vpc_dev.vpc_sub_name
  subnets      = var.vpc.vpc_dev.subnets
}
*/

# Передаем параметры local модулю для создания network and subnet
module "vpc" {
  for_each = var.vpc
  source       = "./vpc"
  vpc_sub_name = each.value.vpc_sub_name
  subnets      = each.value.subnets
}

# Создание кластера БД yandex
module "mdb_mysql_cluster" {
  count = var.cluster_create ? 1 : 0 # Управление созданием кластера в variables.tf
  source = "./mysql"

/* Добавим две переменные network_id и subnet_id к передаваемому основному объекту conf_cl. 
Значение переменных определяют принадлежность к облачной сети и подести. 
Передаем объектами, чтобы не плодить портянку передаваемых переменных, просто передадим целый объект из tfvars */
 
  conf_cl = merge(
    var.conf_root_cl,
    { 
      network_id = module.vpc[var.conf_root_cl.vpc_network].network_id

      # Добавляем условие создания HA если true создаем больше 1 VM, если нет указываем индекс первого блока host
      host = var.conf_root_cl.high_availability ? [

       for p in var.conf_root_cl.host : merge( p, {
         subnet_id = module.vpc["${var.conf_root_cl.vpc_network}"].subnet_id["${var.conf_root_cl.vpc_network}-${p.zone}"]
       })
       ] : [
        merge(var.conf_root_cl.host[0], {
          subnet_id = module.vpc[var.conf_root_cl.vpc_network].subnet_id["${var.conf_root_cl.vpc_network}-${var.conf_root_cl.host[0].zone}"]
        })
        ]
      }
  )

  # Передаем аргументы для создания БД
  conf_db = var.conf_root_db

  ## Передаем аргументы пользователя для созданой БД
  conf_user = merge(
    var.conf_root_user, 
    {
      password = local.passdb
    }
  )
}
