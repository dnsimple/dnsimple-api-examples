# frozen_string_literal: true

app_lib = File.expand_path(__dir__)
$LOAD_PATH.unshift(app_lib) unless $LOAD_PATH.include?(app_lib)

require 'app/configuration'

module App
  module_function

  def config
    @config ||= App::Configuration.new(ENV['RACK_ENV'], ENV['APP_DIR'])
  end
end

require 'app/initializers/dnsimple'
