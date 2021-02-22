# frozen_string_literal: true

module CertificateIssueEventHandler
  module_function

  def handle(event)
    certificate = App::DnsimpleAdapter.download_certificate(
      event.data['certificate']['domain_id'],
      event.data['certificate']['id']
    )
    private_key = App::DnsimpleAdapter.certificate_private_key(
      event.data['certificate']['domain_id'],
      event.data['certificate']['id']
    ).private_key

    p certificate
    p private_key
    # Now you can carry out your business logic of pushing the certificate to
    # your infrastructure automation tool and secrets store.
  end
end
