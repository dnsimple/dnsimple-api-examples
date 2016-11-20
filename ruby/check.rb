#!/usr/bin/env ruby

# To run this script, follow the README to set up your token and then run it as follows:
#
# `./check.rb example.com`
#
require 'pp'
require 'dnsimple'
require_relative 'token'

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
# Here the account ID is extracted for use in future calls..
account_id = response.data.account.id

# Dnsimple::Client::Registrar#check_domain is the method for checking availability for a domain name.
# It expects the account ID and the domain name to check to be passed as arguments.
#
# In this example we simply retrieve the first page of domains.
response = client.registrar.check_domain(account_id, ARGV[0])

# Pretty-print the entire response object so you can see what is inside.
pp response
