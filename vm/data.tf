data "terraform_remote_state" "vm" {
  backend = "local"
  config = {
    path = "../terraform.tfstate"
  }
}
locals {
  vpc_name = data.terraform_remote_state.vm.outputs.vpc_cloud_net  
  network = data.terraform_remote_state.vm.outputs.subnet.network

}

/*Создаем переменную в которую пробрасываем public key ssh с использованием дополнительной 
функцией pathexpand для определениия полного пути по ~, будем указывать в metadata instance */
locals {
  vms_ssh_public_root_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
}


/*
module.vpc[each.value.vpc_network].network_id
[module.vpc[each.value.vpc_network].subnet_id["${var.vpc.dev.vpc_sub_name}-${each.value.subnet_zones[0]}"]]


data.terraform_remote_state.NAME.outputs.VALUE
*/