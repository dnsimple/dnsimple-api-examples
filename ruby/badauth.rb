#!/usr/bin/env ruby
require 'dnsimple'


base_url =  'https://api.sandbox.dnsimple.com'
ARGV.each do |arg|
  base_url = nil if arg.downcase == 'prod' || arg.downcase == 'production'
end

# Construct a client instance.
#
# If you want to connect to production, add command argument `prod`.
# Note that in this case a bogus access token is being sent to show what happens when authentication
# fails.
client = Dnsimple::Client.new(base_url: base_url, access_token: 'fake')

# All calls to client pass through a service. In this case, `client.identity` is the identity service.
#
# Dnsimple::Client::Identity#whoami is the method for retrieving the account details for your
# current credentials via the DNSimple API.
#
# In this case the call will fail and raise an exception.
client.identity.whoami
