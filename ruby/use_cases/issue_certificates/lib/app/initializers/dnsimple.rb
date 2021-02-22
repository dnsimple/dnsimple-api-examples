# frozen_string_literal: true

require 'app/dnsimple_adapter'

App::DnsimpleAdapter.configure do |config|
  config.api_token = App.config.dnsimple['api_token']
  config.account_id = App.config.dnsimple['account_id']
  config.endpoint = App.config.dnsimple['api_endpoint']
end
