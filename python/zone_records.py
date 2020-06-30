#!/usr/bin/env python3

# This script assumes a client token. It will work with an account token but the information is not really useful.
# If all you have is a client token, you can run this script, note the account id, and hard code that into
# other scripts where it is supplying an account id from the whoami endpoint.
import sys

from .auth_token import token
from dnsimple import Client

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
dnsimple.client.zones.list_records is the method to list the records in a DNSimple zone.
"""
response = client.zones.list_records(account_id, str(sys.argv[1]))

for record in response.data:
    print(f'- {record.content} ({record.id})')
