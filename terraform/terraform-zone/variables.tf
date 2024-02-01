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
