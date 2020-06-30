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
dnsimple.client.tlds.get_tld_extended_attributes is the method to retrieve the extended attributes
for a particular TLD.
"""
response = client.tlds.get_tld_extended_attributes(str(sys.argv[1]))

for attribute in response.data:
    print(f'- {attribute.name} ({attribute.description}): required? {attribute.required}')
