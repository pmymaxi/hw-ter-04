variable "conf_cl" {
    type = object({
      name                = string
      environment         = string
      network_id          = string
      version             = string
      #security_group_ids  = list(string)
      deletion_protection = bool
      resources = object({
        resource_preset_id = string
        disk_type_id       = string
        disk_size          = number
      })
      host = list(object({
        zone             = string
        subnet_id        = string
        assign_public_ip = bool
        backup_priority  = number
        priority         = number
      }))
    })
}

variable "conf_db" {
    type = map(string)
}

variable "conf_user" {
    type = object({
      name     = string
      password = string
      roles    = list(string)
    })
}

variable "security_group_ingress" {
  description = "secrules ingress"
  type = list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP"
      description    = "разрешить входящий к mysql"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 3306
    }
  ]
}

variable "security_group_egress" {
  description = "secrules egress"
  type = list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP"
      description    = "разрешить весь исходящий трафик"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 0
      to_port        = 65365
    }
  ]
}