#!/usr/bin/env ruby

# Usage Sandbox: create_contact.rb '{"email":"john.smith@example.com","first_name":"John","last_name":"Smith","address1":"111 SW 1st Street","city":"Miami","state_province":"FL","postal_code":"11111","country":"US","phone":"+1 321 555 4444"}'
# Usage Prod: create_contact.rb prod '{"email":"john.smith@example.com","first_name":"John","last_name":"Smith","address1":"111 SW 1st Street","city":"Miami","state_province":"FL","postal_code":"11111","country":"US","phone":"+1 321 555 4444"}'

require 'pp'
require 'dnsimple'
require_relative 'token'

base_url =  'https://api.sandbox.dnsimple.com'
ARGV.each do |arg|
  base_url = nil if arg.downcase == 'prod' || arg.downcase == 'production'
end

# Construct a client instance.
#
# If you want to connect to production, add command argument `prod` before the user hash argument.
client = Dnsimple::Client.new(base_url: base_url, access_token: TOKEN)

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

contact = Hash[JSON.parse(ARGV.last).map{ |k, v| [k.to_sym, v] }]
puts "Creating contact #{contact}"

# Dnsimple::Client::Contacts#create_contact is the method for a new contact in DNSimple.
response = client.contacts.create_contact(account_id, contact)

# Pretty-print the entire response object so you can see what is inside.
pp response

