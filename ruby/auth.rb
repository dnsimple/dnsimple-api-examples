#!/usr/bin/env ruby
require 'dnsimple'
require_relative 'token'
client = Dnsimple::Client.new(base_url: "https://api.sandbox.dnsimple.com", access_token: TOKEN)
response = client.identity.whoami
puts response.inspect
