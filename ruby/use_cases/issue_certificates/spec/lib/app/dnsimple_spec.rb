# frozen_string_literal: true

require 'rack/test'
require 'app/web'

describe App::Web do
  include Rack::Test::Methods
  let(:app) { described_class.new }

  describe '/dnsimple/events' do
    subject(:request) { post '/dnsimple/events', params }

    let(:params) do
      {
        'data' => {
          'certificate' => {
            "id": '1'
          }
        },
        'name' => 'certificate.issue',
        'actor' => {
          'id' => 'system',
          'entity' => 'dnsimple',
          'pretty' => 'support@dnsimple.com'
        },
        'account' => {
          'id' => '1',
          'display' => 'Personal',
          'identifier' => 'example.user@example.com'
        },
        'api_version' => 'v2',
        'request_identifier' => '9d43f008-ad66-4487-a081-ff1648c93dbe'
      }
    end

    it 'returns status code 200' do
      expect(subject.status).to eq 200
    end

    it 'consumer receives the event for processing' do
      expect(App::Consumers::DnsimpleEventConsumer).to receive(:process)
        .with(params.to_h)

      request
    end
  end
end
