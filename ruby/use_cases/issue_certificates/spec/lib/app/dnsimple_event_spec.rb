# frozen_string_literal: true

require 'app/dnsimple_event'

describe App::DnsimpleEvent do
  it 'serializes incoming dnsimple events correctly' do
    name = 'certificate.issue'
    actor = {
      'id' => 'system',
      'entity' => 'dnsimple',
      'pretty' => 'support@dnsimple.com'
    }
    account = {
      'id' => '1',
      'display' => 'Personal',
      'identifier' => 'example.user@example.com'
    }
    data = {
      'certificate' => {
        "id": '1'
      }
    }
    uuid = '9d43f008-ad66-4487-a081-ff1648c93dbe'
    payload = {
      'data' => data,
      'name' => name,
      'actor' => actor,
      'account' => account,
      'api_version' => 'v2',
      'request_identifier' => uuid
    }

    event = described_class.new(payload)
    expect(event.name).to eq(name)
    expect(event.actor).to eq(actor)
    expect(event.account).to eq(account)
    expect(event.uuid).to eq(uuid)
    expect(event.data).to eq(data)
  end

  describe '#system_actor?' do
    it 'returns true when event was caused by DNSimple system' do
      payload = {
        'actor' => {
          'id' => 'system',
          'entity' => 'dnsimple',
          'pretty' => 'support@dnsimple.com'
        }
      }
      expect(described_class.new(payload).system_actor?).to be(true)
    end

    it 'returns false when event was caused by an Account User' do
      payload = {
        'actor' => {
          'id' => '1',
          'entity' => 'user',
          'pretty' => 'hello@example.com'
        }
      }
      expect(described_class.new(payload).system_actor?).to be(false)
    end
  end
end
