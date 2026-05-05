## Домашнее задание к занятию «Продвинутые методы работы с Terraform»

### Задание 1
#### Cкриншот подключения к консоли и вывод команды ```sudo nginx -t```, консоли ВМ yandex cloud с их метками.
<img width="1912" height="968" alt="1 1" src="https://github.com/user-attachments/assets/8a51824e-e1a1-4951-b39c-272cad150c1f" />

#### Cкриншот terraform console содержимого модуля ```module.vm_module_external.analytics```
<img width="1542" height="1073" alt="1 2" src="https://github.com/user-attachments/assets/ae5c109c-6f8a-46b7-b85e-5cd16a0303df" />

### Задание 2
#### Скриншот вывода информации о yandex_vpc_subnet в root module
<img width="433" height="455" alt="2" src="https://github.com/user-attachments/assets/23c5eb33-1954-459f-b60d-c1ae07c32b09" />

- #### Terraform документация к модулю vpc в каталоге /vpc/README.md
- #### Terraform документация к модулю mysql в каталоге /mysql/README.md
- #### Terraform документация к модулю root в текущем каталоге /TERDOC.md

### Задание 3
Список command по управлению state
```bash
#Удаление vpc:
terraform state rm module.vpc_module_internal

#Удаление vm:
terraform state rm module.vm_module_external

#Вывод в консоль информации из yc о vpc и compute instance, для определения id:
yc compute instance list
yc vpc network list
yc vpc subnet list

#Импорт в state из  yc cloud
terraform import module.vpc_module_internal.yandex_vpc_network.develop 'enpcm95b2qkem55kq8f9'
terraform import module.vpc_module_internal.yandex_vpc_subnet.develop 'e9bv7lh64d09ug160q40'
terraform import 'module.vm_module_external["analytics"].yandex_compute_instance.vm[0]' fhmvul015lbjk3re4fkk
terraform import 'module.vm_module_external["marketing"].yandex_compute_instance.vm[0]' fhm3g6b1t2kgtfd33if3
```
Скриншот выполнения command
<img width="974" height="3022" alt="3" src="https://github.com/user-attachments/assets/81c2e59d-a8d0-49ab-b562-39289dd011b7" />

### Задание 4*
Код модуля vpc так, чтобы он мог создать подсети во всех зонах доступности, переданных в переменной типа list(object) при вызове модуля.
- main.tf
```tf
module "vpc_prod" {
  source       = "./vpc"
  vpc_sub_name = var.vpc.prod.vpc_sub_name
  subnets      = var.vpc.prod.subnets
}
module "vpc_dev" {
  source       = "./vpc"
  vpc_sub_name = var.vpc.dev.vpc_sub_name
  subnets      = var.vpc.dev.subnets
}
```
- tfvars
```tf
vpc = {
  prod = {
    vpc_sub_name = "prod"
    subnets = [
      {
        zone = "ru-central1-a"
        cidr = "10.0.1.0/24"
      },
      {
        zone = "ru-central1-b"
        cidr = "10.0.2.0/24"
      },
      {
        zone = "ru-central1-d"
        cidr = "10.0.3.0/24"
      }
    ]
  }
  dev = {
    vpc_sub_name = "dev"
    subnets = [
      {
        zone = "ru-central1-a"
        cidr = "10.0.1.0/24"
      }
    ]
  }
}
```
- variables.tf
```tf
variable "vpc" {
  type = map(object({
    vpc_sub_name = string
    subnets = list(object({
      zone = string
      cidr = string
    }))
  }))
}
```

- terraform plan deploy модуля vpc
```tf
Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # module.vpc.dev.yandex_vpc_network.develop will be created
  + resource "yandex_vpc_network" "develop" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "dev"
      + subnet_ids                = (known after apply)
    }

  # module.vpc.dev.yandex_vpc_subnet.develop["ru-central1-a"] will be created
  + resource "yandex_vpc_subnet" "develop" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "dev-ru-central1-a"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # module.vpc.prod.yandex_vpc_network.develop will be created
  + resource "yandex_vpc_network" "develop" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "prod"
      + subnet_ids                = (known after apply)
    }

  # module.vpc.prod.yandex_vpc_subnet.develop["ru-central1-a"] will be created
  + resource "yandex_vpc_subnet" "develop" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "prod-ru-central1-a"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # module.vpc.prod.yandex_vpc_subnet.develop["ru-central1-b"] will be created
  + resource "yandex_vpc_subnet" "develop" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "prod-ru-central1-b"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.2.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # module.vpc.prod.yandex_vpc_subnet.develop["ru-central1-d"] will be created
  + resource "yandex_vpc_subnet" "develop" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "prod-ru-central1-d"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.3.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-d"
    }

Plan: 6 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.
```
- Скриншот yc console после выполнения apply
<img width="858" height="316" alt="4" src="https://github.com/user-attachments/assets/55e19695-7934-4257-b4cb-e7b71a5afb94" />

### Задание 5
- terraform plan deploy не только модуля создания кластера, db, user но и проекта в целом
```tf
Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # data.local_file.cluster_info will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "local_file" "cluster_info" {
      + content              = (known after apply)
      + content_base64       = (known after apply)
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + filename             = "./output.log"
      + id                   = (known after apply)
    }

  # data.template_file.metadata will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "template_file" "metadata" {
      + id       = (known after apply)
      + rendered = (known after apply)
      + template = <<-EOT
            #cloud-config

            users:
              - name: ${name}
                groups: ${groups}
                shell: /bin/bash
                sudo: 'ALL=(ALL) NOPASSWD:ALL'
                ssh_authorized_keys:
                  - ${ssh_public}

            chpasswd:
              list: |
                ${name}:${passwd}
              expire: false

            package_update: true
            package_upgrade: true

            packages:
              - nginx
              - curl
        EOT
      + vars     = {
          + "groups"     = "sudo"
          + "name"       = "dops"
          + "passwd"     = <<-EOT
                $6$hdPG5...vmPS4py8.
            EOT
          + "ssh_public" = <<-EOT
                ssh-ed25519 ... dops@dops-desktop-ubnt-03
            EOT
        }
    }

  # null_resource.gen_passwd will be created
  + resource "null_resource" "gen_passwd" {
      + id = (known after apply)
    }

  # null_resource.yc_console_cluster will be created
  + resource "null_resource" "yc_console_cluster" {
      + id       = (known after apply)
      + triggers = {
          + "always_run" = (known after apply)
        }
    }

  # module.mdb_mysql_cluster[0].yandex_mdb_mysql_cluster.clust-mysql-hw-04 will be created
  + resource "yandex_mdb_mysql_cluster" "clust-mysql-hw-04" {
      + allow_regeneration_host   = false
      + backup_retain_period_days = (known after apply)
      + created_at                = (known after apply)
      + deletion_protection       = false
      + disk_encryption_key_id    = (known after apply)
      + environment               = "PRESTABLE"
      + folder_id                 = (known after apply)
      + health                    = (known after apply)
      + host_group_ids            = (known after apply)
      + id                        = (known after apply)
      + mysql_config              = (known after apply)
      + name                      = "example"
      + network_id                = (known after apply)
      + security_group_ids        = (known after apply)
      + status                    = (known after apply)
      + version                   = "8.0"

      + access (known after apply)

      + backup_window_start (known after apply)

      + disk_size_autoscaling (known after apply)

      + host {
          + assign_public_ip   = true
          + backup_priority    = 0
          + fqdn               = (known after apply)
          + priority           = 0
          + replication_source = (known after apply)
          + subnet_id          = (known after apply)
          + zone               = "ru-central1-b"
        }
      + host {
          + assign_public_ip   = true
          + backup_priority    = 0
          + fqdn               = (known after apply)
          + priority           = 0
          + replication_source = (known after apply)
          + subnet_id          = (known after apply)
          + zone               = "ru-central1-a"
        }

      + maintenance_window (known after apply)

      + performance_diagnostics (known after apply)

      + resources {
          + disk_size          = 10
          + disk_type_id       = "network-ssd"
          + resource_preset_id = "c3-c2-m4"
        }
    }

  # module.mdb_mysql_cluster[0].yandex_mdb_mysql_database.test_db will be created
  + resource "yandex_mdb_mysql_database" "test_db" {
      + cluster_id = (known after apply)
      + id         = (known after apply)
      + name       = "test"
    }

  # module.mdb_mysql_cluster[0].yandex_mdb_mysql_user.userdb will be created
  + resource "yandex_mdb_mysql_user" "userdb" {
      + authentication_plugin = (known after apply)
      + cluster_id            = (known after apply)
      + connection_manager    = (known after apply)
      + generate_password     = false
      + id                    = (known after apply)
      + name                  = (sensitive value)
      + password              = (sensitive value)

      + connection_limits (known after apply)

      + permission {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }
    }

  # module.mdb_mysql_cluster[0].yandex_vpc_security_group.mysql-sg will be created
  + resource "yandex_vpc_security_group" "mysql-sg" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "mysql-sg"
      + network_id = (known after apply)
      + status     = (known after apply)

      + egress {
          + description       = "разрешить весь исходящий трафик"
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + protocol          = "TCP"
          + to_port           = 65365
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }

      + ingress {
          + description       = "разрешить входящий к mysql"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 3306
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
    }

  # module.vm_module_external["analytics"].yandex_compute_instance.vm[0] will be created
  + resource "yandex_compute_instance" "vm" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + description               = "TODO: description; {{terraform yyy managed}}"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hardware_generation       = (known after apply)
      + hostname                  = "analytics-vm-webs-0"
      + id                        = (known after apply)
      + labels                    = {
          + "project" = "analytics"
        }
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = (known after apply)
      + name                      = "analytics-vm-webs-0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8odsfqaenpkc1ktb3l"
              + name        = (known after apply)
              + size        = 10
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options (known after apply)

      + network_interface {
          + index          = (known after apply)
          + ip_address     = (known after apply)
          + ipv4           = true
          + ipv6           = (known after apply)
          + ipv6_address   = (known after apply)
          + mac_address    = (known after apply)
          + nat            = false
          + nat_ip_address = (known after apply)
          + nat_ip_version = (known after apply)
          + subnet_id      = (known after apply)
        }

      + placement_policy (known after apply)

      + resources {
          + core_fraction = 5
          + cores         = 2
          + memory        = 1
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # module.vm_module_external["marketing"].yandex_compute_instance.vm[0] will be created
  + resource "yandex_compute_instance" "vm" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + description               = "TODO: description; {{terraform yyy managed}}"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hardware_generation       = (known after apply)
      + hostname                  = "marketing-vm-webs-0"
      + id                        = (known after apply)
      + labels                    = {
          + "project" = "marketing"
        }
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = (known after apply)
      + name                      = "marketing-vm-webs-0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8odsfqaenpkc1ktb3l"
              + name        = (known after apply)
              + size        = 10
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options (known after apply)

      + network_interface {
          + index          = (known after apply)
          + ip_address     = (known after apply)
          + ipv4           = true
          + ipv6           = (known after apply)
          + ipv6_address   = (known after apply)
          + mac_address    = (known after apply)
          + nat            = false
          + nat_ip_address = (known after apply)
          + nat_ip_version = (known after apply)
          + subnet_id      = (known after apply)
        }

      + placement_policy (known after apply)

      + resources {
          + core_fraction = 5
          + cores         = 2
          + memory        = 1
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # module.vpc["dev"].yandex_vpc_network.develop will be created
  + resource "yandex_vpc_network" "develop" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "dev"
      + subnet_ids                = (known after apply)
    }

  # module.vpc["dev"].yandex_vpc_subnet.develop["ru-central1-a"] will be created
  + resource "yandex_vpc_subnet" "develop" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "dev-ru-central1-a"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # module.vpc["prod"].yandex_vpc_network.develop will be created
  + resource "yandex_vpc_network" "develop" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "prod"
      + subnet_ids                = (known after apply)
    }

  # module.vpc["prod"].yandex_vpc_subnet.develop["ru-central1-a"] will be created
  + resource "yandex_vpc_subnet" "develop" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "prod-ru-central1-a"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # module.vpc["prod"].yandex_vpc_subnet.develop["ru-central1-b"] will be created
  + resource "yandex_vpc_subnet" "develop" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "prod-ru-central1-b"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.2.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # module.vpc["prod"].yandex_vpc_subnet.develop["ru-central1-d"] will be created
  + resource "yandex_vpc_subnet" "develop" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "prod-ru-central1-d"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.3.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-d"
    }

Plan: 14 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + subnet     = {
      + network = {
          + dev  = {
              + network_id = (known after apply)
              + subnet_id  = {
                  + dev-ru-central1-a = (known after apply)
                }
            }
          + prod = {
              + network_id = (known after apply)
              + subnet_id  = {
                  + prod-ru-central1-a = (known after apply)
                  + prod-ru-central1-b = (known after apply)
                  + prod-ru-central1-d = (known after apply)
                }
            }
        }
    }
  + yc_console = (known after apply)

─────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.
```


