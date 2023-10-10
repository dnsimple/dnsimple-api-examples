## Global Config
log_level = "INFO"
port      = 8558

syslog {
  enabled = false
}

buffer_period {
  enabled = true
  min     = "5s"
  max     = "20s"
}

# Consul Block
consul {
  address = "consul-server:8500"

  service_registration {
    service_name = "cts"
    address = "cts"
    default_check {
      address = "http://cts:8558"
    }
  }
}

# Driver "terraform" block
driver "terraform" {
  version     = "1.2.9"
  log         = true
  persist_log = false
}

# Task Block
task {
  name        = "dnsimple-task"
  description = "Dynamic DNS record management in DNSimple based on Consul service metadata"
  module      = "dnsimple/cts/dnsimple"

  condition "services" {
    regexp = ".+"
    filter = "Service.Kind != \"connect-proxy\" and Service.Tags contains \"dnsimple\""
  }
  variable_files = ["/consul-terraform-sync/config/terraform.tfvars"]
}
