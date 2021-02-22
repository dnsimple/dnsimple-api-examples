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
  end
end
