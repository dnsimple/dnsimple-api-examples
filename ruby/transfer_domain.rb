#!/usr/bin/env ruby
require 'pp'
require 'dnsimple'
require_relative 'token'

# You can execute this command by running
# ./transfer_domain.rb testing.com registrant_id:2459 auth_code:12345e

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

attributes = {}
ARGV[1..-1].each do |argument|
  key, value = argument.split(":")
  attributes[key.to_sym] = value
end

puts "Transferring domain #{name} with #{attributes} attributes"

# Dnsimple::Client::Registrar#transfer_domain is the method for transferring a domain to DNSimple.
# This will return a Transfer that will start on "transferring" state. You can use the ID to track this transfer.
response = client.registrar.transfer_domain(account_id, name, attributes)

# Pretty-print the entire response object so you can see what is inside.
pp response
