#!/usr/bin/env ruby

require 'dnsimple'

client = Dnsimple::Client.new(access_token: "fake")

response = client.identity.whoami

puts response.inspect
