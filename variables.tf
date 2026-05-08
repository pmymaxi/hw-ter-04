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

/*
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}
*/

variable "vpc" {
  type = map(object({
    vpc_sub_name = string
    subnets = list(object({
      zone = string
      cidr = string
    }))
  }))

}

###example vm_web var
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "example vm_web_ prefix"
}

###example vm_db var
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "example vm_db_ prefix"
}

# Module cluster db yandex mdb
/*variable "conf_cluster" {
  type = map(object({
    name                = string
    environment         = string
    network_id          = string 
    version             = string
    deletion_protection = bool
    resource = object({
      resource_preset_id = string
      disk_type_id       = string
      disk_size          = bool
    })
    host = object({
      zone             = string
      subnet_id        = string
      assign_public_ip = bool
      backup_priority  = number
      priority         = number
    })
    conf_db = map(string)
    conf_user  = object({
      name     = string
      password = string
      roles    = list(string)
    })
  }))
  
}*/

variable "conf_root_cl" {
    type = object({
      name                = string
      environment         = string
      vpc_network         = string
      high_availability   = bool
      version             = string
      deletion_protection = bool
      resources = object({
        resource_preset_id = string
        disk_type_id       = string
        disk_size          = number
      })
      host = list(object({
        zone             = string
        subnet_id        = optional(string)
        assign_public_ip = bool
        backup_priority  = number
        priority         = number
      }))
    })
}

variable "conf_root_db" {
    type = map(string)
}

variable "conf_root_user" {
    type = object({
      name     = string
      roles    = list(string)
    })
    sensitive = true
  
}

# Permission to create a cluster db yandex mdb
variable "cluster_create" {
  type        = bool
  default     = true
  description = "Create cluster db"
}