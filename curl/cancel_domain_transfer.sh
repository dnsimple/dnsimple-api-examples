#!/bin/sh
# Usage: TOKEN=token ./cancel_domain_transfer.sh account_id domain_name transfer_id
#
# Where `account_id` is the numeric ID of the account you are operating on
# `domain_name` is the name of the domain you want to add and
# `transfer_id` is the numeric ID of the domain transfer
curl -i "https://api.sandbox.dnsimple.com/v2/$1/registrar/domains/$2/transfers/$3" -H "Authorization: Bearer ${TOKEN}" -H "Content-type: application/json" -X DELETE
