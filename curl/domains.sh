#!/bin/sh
# Usage: TOKEN=token ./domains.sh account_id
#
# Where `account_id` is the numeric ID of the account you are operating on.
curl -i "https://api.sandbox.dnsimple.com/v2/$1/domains" -H "Authorization: Bearer ${TOKEN}" -H "Accepts: application/json"
