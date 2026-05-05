output "network_id" {
  value = yandex_vpc_network.develop.id
}

output "subnet_id" {
  value = {
    for out in yandex_vpc_subnet.develop :
    out.name => out.id
  }
}
