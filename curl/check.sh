#!/bin/sh
# Usage: TOKEN=token ./check.sh account_id domain_name
curl -i "https://api.sandbox.dnsimple.com/v2/$1/registrar/domains/$2/check" -H "Authorization: Bearer ${TOKEN}" -H "Accepts: application/json"
