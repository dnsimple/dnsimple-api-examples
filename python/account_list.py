#!/usr/bin/env python3

# This script assumes a client token. It will work with an account token but the information is not really useful.
# If all you have is a client token, you can run this script, note the account id, and hard code that into
# other scripts where it is supplying an account id from the whoami endpoint.

from dnsimple import Client
from .auth_token import token

"""
Construct a client instance.

If you want to connect to production omit the sandbox option
"""
client = Client(sandbox=True, access_token=f"{token}")
"""
All calls to client pass through a service. In this case, `client.accounts` is the accounts service

`client.accounts.list_accounts() is the method for retrieving the list of accounts the current authenticated
entity has access to.
"""
response = client.accounts.list_accounts()

account = response.data[0]

print(f'Account= id:{account.id}, email:{account.email}, plan_identifier:{account.plan_identifier}')