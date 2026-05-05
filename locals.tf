/*Создаем переменную в которую пробрасываем public key ssh с использованием дополнительной 
функцией pathexpand для определениия полного пути по ~, будем указывать в metadata instance */
locals {
  vms_ssh_public_root_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
  pass_db = file("passdb.key")
}