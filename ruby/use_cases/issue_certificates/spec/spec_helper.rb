# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
ENV['APP_DIR'] ||= File.expand_path(__dir__)
require 'rspec/matchers'

require_relative '../lib/app'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
