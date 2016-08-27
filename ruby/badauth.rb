#!/usr/bin/env ruby
require 'dnsimple'
client = Dnsimple::Client.new(base_uri: "https://api.sandbox.dnsimple.com", access_token: "fake")
response = client.identity.whoami
puts response.inspect
