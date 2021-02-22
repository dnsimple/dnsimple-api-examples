# frozen_string_literal: true

module App
  module DnsimpleEvent
    attr_reader :name, :actor, :account, :api_version,
                :uuid

    def initialize(payload)
      @payload = payload
      @name = payload['name']
      parse_event_attributes(payload)
    end

    def system_actor?
      @actor['id'] == 'system'
    end

    private

    def parse_event_attributes(payload)
      @actor = payload['actor']
      @account = payload['account']
      @api_version = payload['api_version']
      @uuid = payload['request_identifier']
      @data = payload['data']
    end
  end
end
