#!/usr/bin/env ruby

# Usage: zone_export.rb <directory>
#
# <directory> is the optional path to the directory where the zone files will be written

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
# Here the account ID is extracted for use in the call to list the zone records.
account_id = response.data.account.id

# List all of the zones in the account
response = client.zones.all_zones(account_id)

# For each forward zone, export the zone to a file named after the zone. Use ARGV[0] or . as
# location for each of the zone files.
response.data.select { |zone| !zone.reverse }.map do |zone|
  puts "Exporting #{zone.name}"
  zone_file = client.zones.zone_file(account_id, zone.name).data
  open(File.join(ARGV[0] || File.dirname(__FILE__), "#{zone.name}.zone"), "w") do |f|
    f.write(zone_file.zone)
  end
end
