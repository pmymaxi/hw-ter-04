# Передаем external модулю параметры формирования VM, network и subnet из output модуля "vpc"
module "vm_module_external" {
  for_each = var.vm_module

  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main" # В var не добавляем так как источник должен быть определен заранее
  env_name       = each.value.env_name
  network_id     = local.network[each.value.vpc_network].network_id
  subnet_zones   = each.value.subnet_zones # tolist look at tfvars
  subnet_ids     = [local.network[each.value.vpc_network].subnet_id["${local.vpc_name.dev.vpc_sub_name}-${each.value.subnet_zones[0]}"]]
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