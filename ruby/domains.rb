#!/usr/bin/env ruby
require 'pp'
require 'dnsimple'
require_relative 'token'
client = Dnsimple::Client.new(base_url: "https://api.sandbox.dnsimple.com", access_token: TOKEN)
response = client.identity.whoami
account_id = response.data.account.id

response = client.domains.domains(account_id)

puts
puts "Found #{response.total_entries} domains, showing page #{response.page} or #{response.total_pages}"
domains = response.data
domain_names = domains.map { |domain| domain.name }
longest_name_length = domain_names.map { |name| name.length }.max
puts "Longest domain in chars: #{longest_name_length}"

puts "   #{'Name'.ljust(longest_name_length)}  #{'State'.ljust(10)}  Expiration"
puts "---#{'-' * longest_name_length}--#{'-' * 10}--#{'-' * 'expiration'.length}"
domains.each do |domain|
  print " - #{domain.name.ljust(longest_name_length)}  #{domain.state.ljust(10)}  "
  if domain.state == 'registered'
    print domain.expires_on
  end
  puts
end

puts

