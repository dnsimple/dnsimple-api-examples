#!/usr/bin/env python3

# This script assumes an account token.
#
# If all you have is a user token you can run this script, by passing email and password when creating the client
# like so:
# `client = Client(sandbox=True, email=<your_email>, password=<your_password>`

from dnsimple import Client, DNSimpleException

"""
Construct a client instance.

If you want to connect to production omit the sandbox option
"""
client = Client(sandbox=True, access_token='fake')

"""
All calls to client pass through a service. In this case, `client.identity` is the identity service

`client.identity.whoami() is the method for retrieving the account details for your
current credentials via the DNSimple API.

In this case the call will fail and raise an exception.
"""
try:
    whoami = client.identity.whoami()
except DNSimpleException as e:
    print(f'Exception Raised= {e.message}')
