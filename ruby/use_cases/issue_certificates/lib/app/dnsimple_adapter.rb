# frozen_string_literal: true

require 'dnsimple'

module App
  class DnsimpleAdapter
    class << self
      attr_accessor :api_token, :account_id, :endpoint

      # Set your configuration with block
      def configure
        yield(self)
      end

      # Returns the configuration hash
      #
      # @return [Hash]
      def config
        @config ||= {
          api_token: api_token,
          account_id: account_id,
          endpoint: endpoint
        }.freeze
      end

      # Returns a configured DNSimple API client
      def client
        ::Dnsimple::Client.new(
          base_url: config[:endpoint],
          access_token: config[:api_token]
        )
      end

      def check_domain(domain)
        client.registrar.check_domain(config[:account_id], domain)
      end

      def list_all_contacts
        client.contacts.all_contacts(config[:account_id]).data
      end

      def create_contact(contact_details)
        client.contacts.create_contact(config[:account_id], contact_details)
      end

      def tld_extended_attributes(tld)
        client.tlds.tld_extended_attributes(tld)
      end

      def register_domain(domain, registrant_id, whois_privacy: false, auto_renew: true, extended_attributes: {})
        client.registrar.register_domain(
          config[:account_id],
          domain,
          {
            registrant_id: registrant_id,
            whois_privacy: whois_privacy,
            auto_renew: auto_renew,
            extended_attributes: extended_attributes
          }
        ).data
      end

      def register_webhook(url)
        client.webhooks.create_webhook(config[:account_id], { url: url }).data
      end

      def certificate(domain_id, certificate_id)
        client.certificates.certificate(config[:account_id], domain_id, certificate_id).data
      end

      def download_certificate(domain_id, certificate_id)
        client.certificates.download_certificate(config[:account_id], domain_id, certificate_id).data
      end

      def certificate_private_key(domain_id, certificate_id)
        client.certificates.certificate_private_key(config[:account_id], domain_id, certificate_id).data
      end

      def purchase_letsencrypt_certificate(domain_id, contact_id, name: 'www', alternate_names: nil, auto_renew: false)
        attributes = {
          contact_id: contact_id,
          name: name,
          alternate_names: alternate_names,
          auto_renew: auto_renew
        }
        client.certificates.purchase_letsencrypt_certificate(config[:account_id], domain_id, attributes).data
      end

      def issue_letsencrypt_certificate(domain_id, certificate_id)
        client.certificates.issue_letsencrypt_certificate(config[:account_id], domain_id, certificate_id).data
      end
    end
  end
end
