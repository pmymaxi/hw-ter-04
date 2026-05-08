vm_module = {
  marketing = {
    env_name       = "marketing-vm"
    vpc_network    = "dev"
    subnet_zones   = ["ru-central1-a"]
    instance_name  = "webs"
    instance_count = 1
    image_family   = "ubuntu-2004-lts"
    public_ip      = false
    labels         = { project = "marketing" }
    metadata       = { serial-port-enable = "1" }
    cloud_init = {
      users = {
        name   = "dops"
        groups = "sudo"
      }
      package = {
        package_update  = true
        package_upgrade = true
      }
      packages = [
        "nginx",
        "curl"
      ]
    }
  }

  analytics = {
    env_name       = "analytics-vm"
    vpc_network    = "dev"
    subnet_zones   = ["ru-central1-a"]
    instance_name  = "webs"
    instance_count = 1
    image_family   = "ubuntu-2004-lts"
    public_ip      = false
    labels         = { project = "analytics" }
    metadata       = { serial-port-enable = "1" }
    cloud_init = {
      users = {
        name   = "dops"
        groups = "sudo"
      }
      package = {
        package_update  = true
        package_upgrade = true
      }
      packages = [
        "nginx",
        "curl"
      ]
    }
  }
}
