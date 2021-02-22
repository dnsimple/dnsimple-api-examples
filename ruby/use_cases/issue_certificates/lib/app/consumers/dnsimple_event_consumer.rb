# frozen_string_literal: true

require 'app/dnsimple_event'
require 'app/handlers/certificate_issue_event_handler'

module App
  module Consumers
    module DnsimpleEventConsumer
      PROCESSING_STRATEGIES = {
        'certificate.issue' => App::Handlers::CertificateIssueEventHandler
      }.freeze

      module_function

      # Delegates the processing of an event to the
      # appropriate processor
      #
      # @param payload [Hash] DNSimple webhook event payload
      #
      # @return [void]
      def process(payload)
        return unless relevant_event?(payload)

        event = App::DnsimpleEvent.new(payload)
        PROCESSING_STRATEGIES[event.name].handle
      end

      def relevant_event?(event_name)
        PROCESSING_STRATEGIES.keys.include?(event_name)
      end
    end
  end
end
