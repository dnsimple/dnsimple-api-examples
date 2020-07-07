#!/usr/bin/env python3

# This script assumes an account token.
#
# If all you have is a user token you can run this script, by passing email and password when creating the client
# like so:
# `client = Client(sandbox=True, email=<your_email>, password=<your_password>`

import sys

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
dnsimple.Client.registrar.check_domain is the method for checking the availability for a domain name.

It expects the account id and the domain name to check to be passed as arguments.

In this example we check if the domain (passed as the first command line argument) is available.
"""
response = client.registrar.check_domain(account_id, str(sys.argv[1]))

print(f'Is the domain {response.data.domain} available? {response.data.available}')
