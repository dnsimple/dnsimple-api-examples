#!/bin/sh
# Usage: TOKEN=token ./create_contact.sh account_id contact_data
#
# Where `account_id` is the numeric ID of the account you are operating on and
# `contact_data` is a JSON structure representing the contact.
#
# For example:
#
# `./create_contact.sh 111 '{"email":"anthony@example.com","first_name":"Anthony","last_name":"Eden","address1":"111 SW 1st Street","city":"Miami","state_province":"FL","postal_code":"11111","country":"US","phone":"+1 321 555 4444"}'`
curl -i "https://api.sandbox.dnsimple.com/v2/$1/contacts" -H "Authorization: Bearer ${TOKEN}" -H "Content-type: application/json" -H "Accepts: application/json" -X POST -d "$2"

