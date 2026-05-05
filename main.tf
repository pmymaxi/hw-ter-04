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

# Передаем external модулю параметры формирования VM, network и subnet из output модуля "vpc"
module "vm_module_external" {
  for_each = var.vm_module

  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main" # В var не добавляем так как источник должен быть определен заранее
  env_name       = each.value.env_name
  network_id     = module.vpc[each.value.vpc_network].network_id
  subnet_zones   = each.value.subnet_zones # tolist look at tfvars
  subnet_ids     = [module.vpc[each.value.vpc_network].subnet_id["${var.vpc.dev.vpc_sub_name}-${each.value.subnet_zones[0]}"]]
  instance_name  = each.value.instance_name
  instance_count = each.value.instance_count
  image_family   = each.value.image_family
  public_ip      = each.value.public_ip

  labels = {
    project = each.value.labels.project
  }

#metadata, объединяем key => value из tfvars c формированным template файлом
  metadata = merge(
    var.vm_module.marketing.metadata,
    {
      user-data = data.template_file.metadata.rendered # получаем string черезе rendered
    }
  )
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
      password = local.pass_db
    }
  )
}