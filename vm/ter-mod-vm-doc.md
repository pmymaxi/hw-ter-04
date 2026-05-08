<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.12.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.5 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 5.9.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_vm_module_external"></a> [vm\_module\_external](#module\_vm\_module\_external) | git::https://github.com/udjin10/yandex_compute_instance.git | main |

## Resources

| Name | Type |
| ---- | ---- |
| [external_external.passwd_hash](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [template_file.metadata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [terraform_remote_state.vm](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [vault_generic_secret.pass_vm](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_VAULT_TOKEN"></a> [VAULT\_TOKEN](#input\_VAULT\_TOKEN) | n/a | `string` | n/a | yes |
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id | `string` | n/a | yes |
| <a name="input_default_zone"></a> [default\_zone](#input\_default\_zone) | https://cloud.yandex.ru/docs/overview/concepts/geo-scope | `string` | `"ru-central1-a"` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id | `string` | n/a | yes |
| <a name="input_vm_module"></a> [vm\_module](#input\_vm\_module) | n/a | <pre>map(object({<br/>    env_name       = string<br/>    vpc_network    = string<br/>    subnet_zones   = list(string)<br/>    instance_name  = string<br/>    instance_count = number<br/>    image_family   = string<br/>    public_ip      = bool<br/>    labels         = map(string)<br/>    metadata       = map(string)<br/>    cloud_init = object({<br/>      users    = map(string)<br/>      package  = map(bool)<br/>      packages = list(string)<br/>    })<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->