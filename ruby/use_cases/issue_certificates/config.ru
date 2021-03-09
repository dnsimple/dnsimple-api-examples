# frozen_string_literal: true

ENV['APP_DIR'] ||= File.expand_path(__dir__)

require File.expand_path('lib/app', __dir__)

require 'app/web'

run App::Web
