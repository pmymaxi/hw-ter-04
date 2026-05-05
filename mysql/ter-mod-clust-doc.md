<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.12.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.201.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [yandex_mdb_mysql_cluster.clust-mysql-hw-04](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster) | resource |
| [yandex_mdb_mysql_database.test_db](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_database) | resource |
| [yandex_mdb_mysql_user.userdb](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_user) | resource |
| [yandex_vpc_security_group.mysql-sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_conf_cl"></a> [conf\_cl](#input\_conf\_cl) | n/a | <pre>object({<br/>      name                = string<br/>      environment         = string<br/>      network_id          = string<br/>      version             = string<br/>      #security_group_ids  = list(string)<br/>      deletion_protection = bool<br/>      resources = object({<br/>        resource_preset_id = string<br/>        disk_type_id       = string<br/>        disk_size          = number<br/>      })<br/>      host = list(object({<br/>        zone             = string<br/>        subnet_id        = string<br/>        assign_public_ip = bool<br/>        backup_priority  = number<br/>        priority         = number<br/>      }))<br/>    })</pre> | n/a | yes |
| <a name="input_conf_db"></a> [conf\_db](#input\_conf\_db) | n/a | `map(string)` | n/a | yes |
| <a name="input_conf_user"></a> [conf\_user](#input\_conf\_user) | n/a | <pre>object({<br/>      name     = string<br/>      password = string<br/>      roles    = list(string)<br/>    })</pre> | n/a | yes |
| <a name="input_security_group_egress"></a> [security\_group\_egress](#input\_security\_group\_egress) | secrules egress | <pre>list(object(<br/>    {<br/>      protocol       = string<br/>      description    = string<br/>      v4_cidr_blocks = list(string)<br/>      port           = optional(number)<br/>      from_port      = optional(number)<br/>      to_port        = optional(number)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "description": "разрешить весь исходящий трафик",<br/>    "from_port": 0,<br/>    "protocol": "TCP",<br/>    "to_port": 65365,<br/>    "v4_cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ]<br/>  }<br/>]</pre> | no |
| <a name="input_security_group_ingress"></a> [security\_group\_ingress](#input\_security\_group\_ingress) | secrules ingress | <pre>list(object(<br/>    {<br/>      protocol       = string<br/>      description    = string<br/>      v4_cidr_blocks = list(string)<br/>      port           = optional(number)<br/>      from_port      = optional(number)<br/>      to_port        = optional(number)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "description": "разрешить входящий к mysql",<br/>    "port": 3306,<br/>    "protocol": "TCP",<br/>    "v4_cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ]<br/>  }<br/>]</pre> | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cluster"></a> [cluster](#output\_cluster) | n/a |
| <a name="output_db"></a> [db](#output\_db) | n/a |
| <a name="output_sq"></a> [sq](#output\_sq) | n/a |
| <a name="output_user_db"></a> [user\_db](#output\_user\_db) | n/a |
<!-- END_TF_DOCS -->