# frozen_string_literal: true

require File.expand_path('lib/app', __dir__)

require 'app/web'

ENV['APP_DIR'] ||= File.expand_path(__dir__)

run App::Web
