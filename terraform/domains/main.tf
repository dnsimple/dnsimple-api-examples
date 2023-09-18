terraform {
  required_providers {
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = "1.2.0"
    }
  }
}

provider dnsimple {}

resource "dnsimple_contact" "main" {
  label = "Trusty Person"
  first_name = "Trusty"
  last_name = "Person"
  organization_name = "Trust Co"
  job_title = "Manager"
  address1 = "Level 1, 2 Main St"
  address2 = "Marsfield"
  city = "San Francisco"
  state_province = "California"
  postal_code = "90210"
  country = "US"
  phone = "+18002203458"
  email = "domains@trusty.com"
}

resource "dnsimple_registered_domain" "domain" {
  for_each = toset(jsondecode(file("domains.json")))

  name = each.key
  contact_id = dnsimple_contact.main.id
  auto_renew_enabled    = true
  transfer_lock_enabled = true
  whois_privacy_enabled = false
  dnssec_enabled        = false
}
