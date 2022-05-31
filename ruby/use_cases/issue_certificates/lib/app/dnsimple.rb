# frozen_string_literal: true

require 'sinatra/extension'
require 'sinatra/json'

require 'app/consumers/dnsimple_event_consumer'

module App
  module Dnsimple
    extend Sinatra::Extension

    post '/events' do
      App::Consumers::DnsimpleEventConsumer.process(params.to_h)
    end

    post '/issue_certificate' do
      certificate_order = App::DnsimpleAdapter.purchase_letsencrypt_certificate(
        parsed_request_body['domain'],
        name: parsed_request_body['name'],
        alternate_names: parsed_request_body['san']&.split(','),
        auto_renew: parsed_request_body.fetch('auto_renew', true)
      )
      certificate = App::DnsimpleAdapter.issue_letsencrypt_certificate(parsed_request_body['domain'],
                                                                       certificate_order.certificate_id)

      json(data: {
             certificate_id: certificate.id,
             common_name: certificate.common_name,
             san: certificate.alternate_names,
             state: certificate.state,
             auto_renew: certificate.auto_renew
           })
    rescue ::Dnsimple::NotFoundError, ::Dnsimple::RequestError => e
      halt 400, json(error: { message: e.message })
    end
  end
end
