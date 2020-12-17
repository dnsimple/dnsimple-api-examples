#!/bin/sh
# Usage: TOKEN=token ./transfer_domain.sh account_id domain_name registrant_id auth_code
#
# Where `account_id` is the numeric ID of the account you are operating on
# `domain_name` is the name of the domain you want to add
# `registrant_id` is the numeric ID of the contact you want to use to register the domain and
# `auth_code` is the authorization code that will be used to transfer the domain.
curl -i "https://api.sandbox.dnsimple.com/v2/$1/registrar/domains/$2/transfers" -H "Authorization: Bearer ${TOKEN}" -H "Content-type: application/json" -H "Accepts: application/json" -X POST -d "{\"registrant_id\": \"$3\", \"auth_code\": \"$4\"}"
