#!/usr/bin/env ruby

# To run this script, follow the README to set up your token and then run it as follows:
#
# `./tld_extended_attributes.rb co.uk`
#
require 'pp'
require 'dnsimple'
require_relative 'token'

# Construct a client instance.
#
# If you want to connect to production, omit the `base_url` option.
client = Dnsimple::Client.new(base_url: "https://api.sandbox.dnsimple.com", access_token: TOKEN)

# Dnsimple::Client::Tld#extended_attributes is the method to retrieve the extended attributes
# for a particular TLD.
response = client.tlds.extended_attributes(ARGV[0])

# Pretty-print the entire response object so you can see what is inside.
pp response
