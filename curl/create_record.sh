#!/bin/sh
# Usage: TOKEN=token ./create_record.sh account_id domain_name record_name record_type record_content record_ttl
#
# Where `account_id` is the numeric ID of the account you are operating on and
# `domain_name` is the name of the domain you want to add.
curl -i "https://api.sandbox.dnsimple.com/v2/$1/zones/$2/records" -H "Authorization: Bearer ${TOKEN}" -H "Content-type: application/json" -H "Accepts: application/json" -X POST -d "{\"name\": \"$3\",\"type\": \"$4\",\"content\": \"$5\", \"ttl\": \"$6\"}"
