# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/namespace'

require 'app/dnsimple'

module App
  class Web < Sinatra::Base
    set :root, Dir.getwd

    configure :production, :development do
      enable :logging
    end

    enable :raise_errors

    register Sinatra::Namespace

    namespace '/dnsimple' do
      register App::Dnsimple
    end
  end
end
