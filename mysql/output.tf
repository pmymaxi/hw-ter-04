output "cluster" {
  value = yandex_mdb_mysql_cluster.clust-mysql-hw-04
}
output "db" {
  value = yandex_mdb_mysql_database.test_db
}
output "user_db" {
  value = yandex_mdb_mysql_user.userdb
}
output "sq" {
  value = yandex_vpc_security_group.mysql-sg
}