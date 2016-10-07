#!/bin/sh
# Usage: TOKEN=token ./create_domain.sh account_id domain_name
#
# Where `account_id` is the numeric ID of the account you are operating on and
# `domain_name` is the name of the domain you want to add.
curl -i "https://api.sandbox.dnsimple.com/v2/$1/domains" -H "Authorization: Bearer ${TOKEN}" -H "Content-type: application/json" -H "Accepts: application/json" -X POST -d "{\"name\": \"$2\"}"
