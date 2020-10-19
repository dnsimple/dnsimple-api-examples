#!/usr/bin/env python3

# This script assumes an account token.
#
# If all you have is a user token you can run this script, by passing email and password when creating the client
# like so:
# `client = Client(sandbox=True, email=<your_email>, password=<your_password>`

import argparse

from auth_token import token
from dnsimple import Client
from dnsimple.struct import Contact

parser = argparse.ArgumentParser()
parser.add_argument("first_name", help="The contact first name")
parser.add_argument("last_name", help="The contact last name")
parser.add_argument("address1", help="The contact street address")
parser.add_argument("city", help="The city name")
parser.add_argument("state_province", help="The state or province name")
parser.add_argument("postal_code", help="The contact postal code")
parser.add_argument("country", help="The contact country (as a 2-character country code)")
parser.add_argument("email", help="The contact email address")
parser.add_argument("phone", help="The contact phone number")
parser.add_argument("--label", help="The label to represent the contact")
parser.add_argument("--organization_name", help="The company name. If the organization_name is specified, then you must also include job_title.")
parser.add_argument("--job_title", help="The contact's job title")
parser.add_argument("--address2", help="Apartment or suite number")
parser.add_argument("--fax", help="The contact fax number")
parser.set_defaults(label="", organization_name="", job_title="", address2="", fax="")

args = parser.parse_args()

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

contact = Contact.new(label=args.label, first_name=args.first_name, last_name=args.last_name, job_title=args.job_title,
                      organization_name=args.organization_name, email=args.email, phone=args.phone,
                      fax=args.fax, address1=args.address1, address2=args.address2, city=args.city,
                      state_province=args.state_province, postal_code=args.postal_code, country=args.country)

response = client.contacts.create_contact(account_id, contact)

print(f'Created contact: {response.data.first_name} with id {response.data.id}')
