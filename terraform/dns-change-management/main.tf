locals {
  domain = "dns.solutions"
}

resource "dnsimple_zone_record" "demo" {
  zone_name = local.domain
  name      = "demo"
  value     = "https://dnsimple.com"
  type      = "URL"
  ttl       = 60
}

resource "dnsimple_zone_record" "dnsimple" {
  zone_name = local.domain
  name      = "dnsimple"
  value     = "https://dnsimple.com"
  type      = "URL"
  ttl       = 60
}

resource "dnsimple_zone_record" "terraform" {
  zone_name = local.domain
  name      = "terraform"
  value     = "https://dnsimple.com/a/118785/domains/dns.solutions"
  type      = "URL"
  ttl       = 60
}

resource "dnsimple_zone_record" "consul" {
  zone_name = local.domain
  name      = "consul"
  value     = "https://dnsimple.com/a/118785/domains/devswelcome.com"
  type      = "URL"
  ttl       = 60
}

resource "dnsimple_zone_record" "terraforming" {
  zone_name = local.domain
  name      = "terraforming"
  value     = "https://dnsimple.com/hashicorp"
  type      = "URL"
  ttl       = 60
}

resource "dnsimple_zone_record" "test" {
  zone_name = local.domain
  name      = "test"
  value     = "127.0.0.1"
  type      = "A"
  ttl       = 60
}
