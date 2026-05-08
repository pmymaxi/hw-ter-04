# Читаем secret path из VAULT
data "vault_generic_secret" "pass_db" {
  path = "secret/sec-hw-terraform"
}
# Создаем локальную переменную metadata vm и hash пароля
locals {
  passdb = data.vault_generic_secret.pass_db.data["db"]
}