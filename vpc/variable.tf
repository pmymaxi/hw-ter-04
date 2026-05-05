variable "vpc_sub_name" {
    type = string
    default = "NoName"
}
variable "subnets" {
    type = list(object({
      zone = string
      cidr = string
    }))
}