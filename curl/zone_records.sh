#!/bin/sh
# Usage: TOKEN=token ./domains.sh account_id domain_name
#
# Where `account_id` is the numeric ID of the account you are operating on and
# `domain_name` is the domain name you want to list the records for
curl -i "https://api.sandbox.dnsimple.com/v2/$1/zones/$2/records" -H "Authorization: Bearer ${TOKEN}" -H "Accepts: application/json"

