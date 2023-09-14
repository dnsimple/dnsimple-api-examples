terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = "~> 1.1.2"
    }
  }
}

provider "docker" {}

provider "dnsimple" {
  token   = var.dnsimple_token
  account = var.dnsimple_account
}

variable "dnsimple_token" {
  description = "DNSimple API Token"
  type        = string
  sensitive   = true
}

variable "dnsimple_account" {
  description = "DNSimple Account ID"
  type        = string
}

variable "dnsimple_domain" {
  description = "DNSimple Domain"
  type        = string
}

resource "dnsimple_registered_domain" "domain" {
  name = "${var.dnsimple_domain}"

  contact_id            = 45600
  auto_renew_enabled    = true
  whois_privacy_enabled = true
  dnssec_enabled        = false
}

# Order a new let's encrypt certificate
resource "dnsimple_lets_encrypt_certificate" "certificate_order" {
    domain_id  = dnsimple_registered_domain.domain.id
    auto_renew = false
    name       = "www"
}

# dnsimple_lets_encrypt_certificate.state must be 'issued' to proceed.
data "dnsimple_certificate" "certificate" {
  domain         = dnsimple_registered_domain.domain.name
  certificate_id = dnsimple_lets_encrypt_certificate.certificate_order.id
}

resource "local_file" "certificate_pem" {
  content  = templatefile("${path.module}/templates/nginx.pem.tftpl", { 
    server_certificate = data.dnsimple_certificate.certificate.server_certificate, 
    certificate_chain = data.dnsimple_certificate.certificate.certificate_chain 
  })
  filename        = "${path.module}/../nginx/ssl/nginx.pem"
  file_permission = 0640
}

resource "local_file" "certificate_key" {
  content         = data.dnsimple_certificate.certificate.private_key
  filename        = "${path.module}/../nginx/ssl/nginx.key"
  file_permission = 0600
}

resource "local_file" "nginx_conf" {
  content = templatefile("${path.module}/templates/default.conf.tftpl", {
    server_name = data.dnsimple_certificate.certificate.domain
  })
  filename        = "${path.module}/../nginx/default.conf"
  file_permission = 0640
}

resource "docker_image" "terraform_tls_demo" {
  name = "terraform-tls-demo"
  
  build {
    context = "${path.module}/.."
    tag     = ["latest"]
  }
}

resource "docker_container" "terraform_tls_demo" {
  name = "terraform-tls-demo"
  image = docker_image.terraform_tls_demo.image_id

  ports {
    ip = "127.0.0.1"
    internal = 80
    external = 8080
  }

  ports {
    ip = "127.0.0.1"
    internal = 443
    external = 8443
  }
}
