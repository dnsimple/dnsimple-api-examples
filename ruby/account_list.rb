#!/usr/bin/env ruby

# This script assumes a client token. It will work with an account token but the information is not really useful.
# If all you have is a client token, you can run this script, note the account id, and hard code that into
# other scripts where it is supplying an account id from the whoami endpoint.


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
response = client.accounts.list

# Note:
#      data.user property will be nil if an account token was supplied
#      data.account property will be nil if a user token was supplied

# Pretty-print the entire response object so you can see what is inside.
pp response
