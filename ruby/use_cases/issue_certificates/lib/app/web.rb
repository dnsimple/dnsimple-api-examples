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

    helpers do
      def parsed_request_body
        request_data = if request.content_type.include?('multipart/form-data;')
                         params
                       else
                         request.body.rewind
                         JSON.parse(request.body.read)
                       end
        halt(400, json(error: { message: 'The request body must be a JSON hash' })) unless request_data.is_a?(Hash)
        request_data
      end
    end

    namespace '/dnsimple' do
      register App::Dnsimple
    end
  end
end
