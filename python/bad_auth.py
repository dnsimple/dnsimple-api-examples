#!/usr/bin/env python3

# This script assumes a client token. It will work with an account token but the information is not really useful.
# If all you have is a client token, you can run this script, note the account id, and hard code that into
# other scripts where it is supplying an account id from the whoami endpoint.
from dnsimple import Client

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
