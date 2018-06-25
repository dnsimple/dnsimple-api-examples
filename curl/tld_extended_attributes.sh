#!/bin/sh
# Usage: TOKEN=token ./tld_extended_attributes.sh tld
curl -i "https://api.sandbox.dnsimple.com/v2/tlds/$1/extended_attributes" -H "Authorization: Bearer ${TOKEN}" -H "Accepts: application/json"
