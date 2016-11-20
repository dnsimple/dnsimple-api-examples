#!/usr/bin/env ruby
require 'pp'
require 'dnsimple'
require_relative 'token'

base_url =  'https://api.sandbox.dnsimple.com'
ARGV.each do |arg|
  base_url = nil if arg.downcase == 'prod' || arg.downcase == 'production'
end

# Construct a client instance.
#
# If you want to connect to production, add command argument `prod`.
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
# Here the account ID is extracted for use in the call to list domains.
account_id = response.data.account.id

# Dnsimple::Client::Domains#domains is the method for retrieving a page from the list of domains
# in an account. The default page size is 30 domains. If your account has more than 30 domains then
# you can page through the results with repeated calls to `#domains` or you can use the `#all_domains`
# method for automatic paging.
#
# In this example we simply retrieve the first page of domains.
response = client.domains.domains(account_id)

# Pretty-print the entire response object so you can see what is inside.
pp response
