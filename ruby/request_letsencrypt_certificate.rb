#!/usr/bin/env ruby

# Usage: ENV["CERTIFICATE_DOMAIN_ID"]=example.com ruby ./request_letsencrypt_certificate.rb

require 'pp'
require 'dnsimple'
require_relative 'token'

ENV["CERTIFICATE_DOMAIN_ID"] or
    abort("set CERTIFICATE_DOMAIN_ID to the ID of the domain to request the certificate for")

# Construct a client instance.
#
# If you want to connect to production, omit the `base_url` option.
client = Dnsimple::Client.new(base_url: "https://api.sandbox.dnsimple.com", access_token: TOKEN)

# All calls to client pass through a service. In this case, `client.identity` is the identity service.
#
# Dnsimple::Client::Identity#whoami is the method for retrieving the account details for your
# current credentials via the DNSimple API.
response = client.identity.whoami

# The response object returned by any API method includes a `data` attribute. Underneath that
# attribute is an attribute for each data object returned. In this case, `#account` provides
# access to the resulting account object.
#
# Here the account ID is extracted for use in the call to create contact.
account_id = response.data.account.id

# Dnsimple::Client::Certificates#purchase_letsencrypt_certificate is the method to create a certificate order.
response = client.certificates.purchase_letsencrypt_certificate(account_id, ENV["CERTIFICATE_DOMAIN_ID"], { name: ENV["CERTIFICATE_NAME"] || "www" })

# Pretty-print the entire response object so you can see what is inside.
pp response

# Dnsimple::Client::Certificates#create_contact is the method to submit the order for issuace.
response = client.certificates.issue_letsencrypt_certificate(account_id, ENV["CERTIFICATE_DOMAIN_ID"], response.data.id)

# Pretty-print the entire response object so you can see what is inside.
pp response
