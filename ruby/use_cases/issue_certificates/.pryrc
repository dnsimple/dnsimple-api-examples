# frozen_string_literal: true

ENV['APP_DIR'] ||= File.expand_path(__dir__)

require 'bundler/setup'
require File.expand_path('lib/app', __dir__)
