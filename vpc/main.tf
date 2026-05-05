terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.12.0"
}


resource "yandex_vpc_network" "develop" {
  name = var.vpc_sub_name
}
resource "yandex_vpc_subnet" "develop" {
  for_each =  { 
    for key in var.subnets :
      key.zone => key
  }

  name           = "${var.vpc_sub_name}-${each.value.zone}"
  network_id     = yandex_vpc_network.develop.id
  zone           = each.value.zone
  v4_cidr_blocks = [each.value.cidr]

}