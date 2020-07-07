#!/usr/bin/env python3

# This script assumes an account token.
#
# If all you have is a user token you can run this script, by passing email and password when creating the client
# like so:
# `client = Client(sandbox=True, email=<your_email>, password=<your_password>`

from dnsimple import Client

from auth_token import token

"""
Construct a client instance.

If you want to connect to production omit the sandbox option
"""
client = Client(sandbox=True, access_token=token)

"""
All calls to client pass through a service. In this case, `client.identity` is the identity service

`client.identity.whoami() is the method for retrieving the account details for your
current credentials via the DNSimple API.
"""
response = client.identity.whoami()

"""
The response object returned by any API method includes a `data` attribute.

Underneath that attribute is an attribute for each data object returned.

In this case, `account` provides access to the contained account object.

Here the account id is extracted for use in future calls:
"""
account_id = response.data.account.id

"""
dnsimple.client.domains.list_domains is the method for retrieving a page from the list of domains
in an account. The default page size is 30 domains. If your account has more that 30 domains then
you can page through the results with repeated calls to list_domains using the page and per_page options.

In this example we simply retrieve the first page of the domain list"""
response = client.domains.list_domains(account_id)

print("Domains found:")
for domain in response.data:
    print(f"    - {domain.name}({domain.id})")
