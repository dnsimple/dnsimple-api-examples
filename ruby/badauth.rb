#!/usr/bin/env ruby
require 'dnsimple'

# Construct a client instance.
#
# If you want to connect to production, omit the `base_url` option.
#
# Note that in this case a bogus access token is being sent to show what happens when authentication
# fails.
client = Dnsimple::Client.new(base_url: "https://api.sandbox.dnsimple.com", access_token: "fake")

# All calls to client pass through a service. In this case, `client.identity` is the identity service.
#
# Dnsimple::Client::Identity#whoami is the method for retrieving the account details for your
# current credentials via the DNSimple API.
#
# In this case the call will fail and raise an exception.
client.identity.whoami
