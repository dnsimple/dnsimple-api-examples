locals {
  # Customize the domain name
  domain = "87c1b7e6-8b57-4129-a1ae-cd73027a68c8.com"
}

resource "dnsimple_zone_record" "bd261c9c" {
  zone_name = local.domain
  name      = ""
  type      = "A"
  value     = "93.184.216.34"
  ttl       = 3600
}

resource "dnsimple_zone_record" "f94cb76a" {
  zone_name = local.domain
  name      = ""
  type      = "AAAA"
  value     = "2606:2800:220:1:248:1893:25c8:1946"
  ttl       = 3600
}

resource "dnsimple_zone_record" "www" {
  zone_name = local.domain
  name      = "www"
  type      = "URL"
  value     = "https://dnsimple.com"
  ttl       = 3600
}

resource "dnsimple_zone_record" "fff2bb56" {
  zone_name = local.domain
  name      = ""
  value     = "mail.example.com"
  type      = "MX"
  ttl       = 3600
}
