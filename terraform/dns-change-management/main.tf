locals {
  dns_solutions = "dns.solutions"
}

resource "dnsimple_zone_record" "apex" {
  zone_name = local.dns_solutions
  name      = ""
  value     = "https://dnsimple.com"
  type      = "URL"
  ttl       = 60
}

resource "dnsimple_zone_record" "www" {
  zone_name = local.dns_solutions
  name      = "www"
  value     = "https://dnsimple.com"
  type      = "URL"
  ttl       = 60
}

resource "dnsimple_zone_record" "terraform" {
  zone_name = local.dns_solutions
  name      = "terraform"
  value     = "https://dnsimple.com/a/118785/domains/dns.solutions"
  type      = "URL"
  ttl       = 60
}

resource "dnsimple_zone_record" "consul" {
  zone_name = local.dns_solutions
  name      = "consul"
  value     = "https://dnsimple.com/a/118785/domains/devswelcome.com"
  type      = "URL"
  ttl       = 60
}

resource "dnsimple_zone_record" "terraforming" {
  zone_name = local.dns_solutions
  name      = "terraforming"
  value     = "https://dnsimple.com/hashicorp"
  type      = "URL"
  ttl       = 60
}

resource "dnsimple_zone_record" "test" {
  zone_name = local.dns_solutions
  name      = "test"
  value     = "1.2.3.4"
  type      = "A"
  ttl       = 60
}
