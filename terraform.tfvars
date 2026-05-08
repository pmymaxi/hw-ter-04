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

# Cluster mysql db

  conf_root_cl = {
    name                = "example"
    environment         = "PRESTABLE"
    vpc_network         = "prod"
    high_availability   = true
    version             = "8.0"
    deletion_protection = false
    resources = {
      resource_preset_id = "c3-c2-m4"
      disk_type_id       = "network-ssd"
      disk_size          = 10
    }
    host = [
      {
      zone             = "ru-central1-b"
      assign_public_ip = true
      backup_priority  = 0
      priority         = 0
    },
    {
      zone             = "ru-central1-a"
      assign_public_ip = true
      backup_priority  = 0
      priority         = 0
    }
    ]

  }

  conf_root_db = {
    name = "test"
    }
  conf_root_user = {
    name = "app"
    roles = ["ALL"]
  }