#!/usr/bin/env python3

# This script assumes an account token.
#
# If all you have is a user token you can run this script, by passing email and password when creating the client
# like so:
# `client = Client(sandbox=True, email=<your_email>, password=<your_password>`

import sys

from auth_token import token
from dnsimple import Client

"""
Construct a client instance.

If you want to connect to production omit the sandbox option
"""
client = Client(sandbox=True, access_token=token)

"""
dnsimple.client.tlds.get_tld_extended_attributes is the method to retrieve the extended attributes
for a particular TLD.
"""
response = client.tlds.get_tld_extended_attributes(str(sys.argv[1]))

for attribute in response.data:
    print(f'- {attribute.name} ({attribute.description}): required? {attribute.required}')
