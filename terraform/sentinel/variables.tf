variable "dnsimple_token" {
  type      = string
  sensitive = true
}

variable "dnsimple_account" {
  type      = string
  sensitive = false
}

variable "dnsimple_sandbox" {
  type      = bool
  sensitive = false
  default   = true
}

variable "dnsimple_domain_a" {
  type      = string
  sensitive = false
}

variable "dnsimple_contact_id" {
  type      = number
  sensitive = false
}

variable "dnsimple_domain_b" {
  type      = string
  sensitive = false
}
