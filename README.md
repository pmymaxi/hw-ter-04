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
Скриншот yc console после выполнения apply
<img width="858" height="316" alt="4" src="https://github.com/user-attachments/assets/55e19695-7934-4257-b4cb-e7b71a5afb94" />

