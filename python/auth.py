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
Note:
    data.user property will be None if an account token was supplied
    data.account property will be None if a user token was supplied
"""
account = response.data.account

print(f'Account= id:{account.id}, email:{account.email}, plan_identifier:{account.plan_identifier}')
