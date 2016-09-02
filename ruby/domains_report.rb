#!/usr/bin/env ruby
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
# Here the account ID is extracted for use in the call to list domains.
account_id = response.data.account.id

# Dnsimple::Client::Domains#domains is the method for retrieving a page from the list of domains
# in an account. The default page size is 30 domains. If your account has more than 30 domains then
# you can page through the results with repeated calls to `#domains` or you can use the `#all_domains`
# method for automatic paging.
#
# In this example we simply retrieve the first page of domains.
response = client.domains.domains(account_id)

# Just like the whoami response above, the response object from the `#domains` method has a 
# data attribute. In this case it is an array with multiple domains.
domains = response.data

# This line is used to find the domain name with the longest length. It is used in the reporting
# section below to figure out how to properly left-justify the domain names so they appear in a
# single column.
longest_name_length = domains.map { |domain| domain.name.length }.max

# Below this line combines the data extracted from the API into a simple text report.
# ----------------------

puts

# Header for the report.
puts "Found #{response.total_entries} domains, showing page #{response.page} or #{response.total_pages}"
puts "Longest domain in chars: #{longest_name_length}"
puts "   #{'Name'.ljust(longest_name_length)}  #{'State'.ljust(10)}  Expiration"
puts "---#{'-' * longest_name_length}--#{'-' * 10}--#{'-' * 'expiration'.length}"

# Go through each domain in the array of domains and print its name, state and expiration date
# if the domain is in the `registered` state.
domains.each do |domain|
  print " - #{domain.name.ljust(longest_name_length)}  #{domain.state.ljust(10)}  "
  if domain.state == 'registered'
    print domain.expires_on
  end
  puts
end
puts
