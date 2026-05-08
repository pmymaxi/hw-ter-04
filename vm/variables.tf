variable "VAULT_TOKEN" {
  type = string
  sensitive = true
}
###cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}


variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vm_module" {
  type = map(object({
    env_name       = string
    vpc_network    = string
    subnet_zones   = list(string)
    instance_name  = string
    instance_count = number
    image_family   = string
    public_ip      = bool
    labels         = map(string)
    metadata       = map(string)
    cloud_init = object({
      users    = map(string)
      package  = map(bool)
      packages = list(string)
    })
  }))
}