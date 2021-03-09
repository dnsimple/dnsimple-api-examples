# frozen_string_literal: true

require 'json'

module App
  class Configuration
    attr_reader :env

    def initialize(env, app_dir)
      @env = env || 'development'
      @config = load_config_from_file(File.join(app_dir, '.config.json'))
    end

    def development?
      env == 'development'
    end

    def dnsimple
      @config['dnsimple']
    end

    private

    def load_config_from_file(path)
      JSON.parse(File.read(path))
    end
  end
end
