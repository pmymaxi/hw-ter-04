<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.12.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_local"></a> [local](#provider\_local) | 2.8.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_mdb_mysql_cluster"></a> [mdb\_mysql\_cluster](#module\_mdb\_mysql\_cluster) | ./mysql | n/a |
| <a name="module_vm_module_external"></a> [vm\_module\_external](#module\_vm\_module\_external) | git::https://github.com/udjin10/yandex_compute_instance.git | main |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./vpc | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [null_resource.gen_passwd](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.yc_console_cluster](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [local_file.cluster_info](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [template_file.metadata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id | `string` | n/a | yes |
| <a name="input_cluster_create"></a> [cluster\_create](#input\_cluster\_create) | Create cluster db | `bool` | `true` | no |
| <a name="input_conf_root_cl"></a> [conf\_root\_cl](#input\_conf\_root\_cl) | n/a | <pre>object({<br/>      name                = string<br/>      environment         = string<br/>      vpc_network         = string<br/>      high_availability   = bool<br/>      version             = string<br/>      deletion_protection = bool<br/>      resources = object({<br/>        resource_preset_id = string<br/>        disk_type_id       = string<br/>        disk_size          = number<br/>      })<br/>      host = list(object({<br/>        zone             = string<br/>        subnet_id        = optional(string)<br/>        assign_public_ip = bool<br/>        backup_priority  = number<br/>        priority         = number<br/>      }))<br/>    })</pre> | n/a | yes |
| <a name="input_conf_root_db"></a> [conf\_root\_db](#input\_conf\_root\_db) | n/a | `map(string)` | n/a | yes |
| <a name="input_conf_root_user"></a> [conf\_root\_user](#input\_conf\_root\_user) | n/a | <pre>object({<br/>      name     = string<br/>      roles    = list(string)<br/>    })</pre> | n/a | yes |
| <a name="input_default_zone"></a> [default\_zone](#input\_default\_zone) | https://cloud.yandex.ru/docs/overview/concepts/geo-scope | `string` | `"ru-central1-a"` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id | `string` | n/a | yes |
| <a name="input_vm_db_name"></a> [vm\_db\_name](#input\_vm\_db\_name) | example vm\_db\_ prefix | `string` | `"netology-develop-platform-db"` | no |
| <a name="input_vm_module"></a> [vm\_module](#input\_vm\_module) | n/a | <pre>map(object({<br/>    env_name       = string<br/>    vpc_network    = string<br/>    subnet_zones   = list(string)<br/>    instance_name  = string<br/>    instance_count = number<br/>    image_family   = string<br/>    public_ip      = bool<br/>    labels         = map(string)<br/>    metadata       = map(string)<br/>    cloud_init = object({<br/>      users    = map(string)<br/>      package  = map(bool)<br/>      packages = list(string)<br/>    })<br/>  }))</pre> | n/a | yes |
| <a name="input_vm_web_name"></a> [vm\_web\_name](#input\_vm\_web\_name) | example vm\_web\_ prefix | `string` | `"netology-develop-platform-web"` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | n/a | <pre>map(object({<br/>    vpc_sub_name = string<br/>    subnets = list(object({<br/>      zone = string<br/>      cidr = string<br/>    }))<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_subnet"></a> [subnet](#output\_subnet) | Выводим информацию о network and subnet |
| <a name="output_yc_console"></a> [yc\_console](#output\_yc\_console) | Выводим log файл вывода из yc console |
<!-- END_TF_DOCS -->
