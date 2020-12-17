#!/usr/bin/env ruby
require 'pp'
require 'dnsimple'
require_relative 'token'

# You can execute this command by running
# ./cancel_domain_transfer.rb testing.com 42
# where 42 is the domain transfer id

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
# Here the account ID is extracted for use in the call to list domains.
account_id = response.data.account.id

name = ARGV.first
transfer_id = ARGV.last

puts "Cancelling transfer #{transfer_id} for domain #{name}"

# Dnsimple::Client::Registrar#cancel_domain_transfer is the method for cancelling a domain transfer
# if it is still in progress.
response = client.registrar.cancel_domain_transfer(account_id, name, transfer_id)

# Pretty-print the entire response object so you can see what is inside.
pp response
