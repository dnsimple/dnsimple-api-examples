# frozen_string_literal: true

ENV['APP_DIR'] ||= File.expand_path(__dir__)

require 'bundler/setup'
require File.expand_path('lib/app', __dir__)

require 'net/http'

def setup_webhook
  port = 4040
  response = Net::HTTP.get_response(ENV.fetch('NGROK_API_URL', 'localhost'), '/api/tunnels', port)
  return puts('API responded with non 200 status') if response.code == 200

  https_tunnel = JSON.parse(response.body)['tunnels'].detect { |tunnel| tunnel['proto'] == 'https' }
  App::DnsimpleAdapter.register_webhook(URI.join(https_tunnel['public_url'], 'dnsimple/events'))
end

def clear_all_webhooks
  App::DnsimpleAdapter.all_webhooks.each do |webhook|
    next unless /ngrok\.io/.match?(webhook.url)

    App::DnsimpleAdapter.delete_webhook(webhook.id)
  end
end
