terraform {
  required_providers {
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = "~> 2.1.2"
    }
  }
}

provider "dnsimple" {
  token   = var.dnsimple_token
  account = var.dnsimple_account
  sandbox = var.dnsimple_sandbox
}
