resource "dnsimple_registered_domain" "domain_a" {
  contact_id = var.dnsimple_contact_id
  name       = var.dnsimple_domain_a

  auto_renew_enabled    = true
  dnssec_enabled        = true
  transfer_lock_enabled = true
  whois_privacy_enabled = false
}

resource "dnsimple_registered_domain" "domain_b" {
  contact_id = var.dnsimple_contact_id
  name       = var.dnsimple_domain_b

  auto_renew_enabled    = true
  dnssec_enabled        = true
  transfer_lock_enabled = true
  whois_privacy_enabled = false
}

resource "dnsimple_domain_delegation" "domain_a" {
  domain = dnsimple_registered_domain.domain_a.name
  name_servers = [
    "ns1.dnsimple.com",
    "ns2.dnsimple.com",
    "ns3.dnsimpl.com",
    "ns4.dnsimple-edge.org",
  ]
}

resource "dnsimple_domain_delegation" "domain_b" {
  domain = dnsimple_registered_domain.domain_b.name
  name_servers = [
    "ns1.dnsimple.com",
    "ns2.dnsimple.com",
    "ns3.dnsimple.com",
    "ns4.dnsimple-edge.org",
  ]
}
