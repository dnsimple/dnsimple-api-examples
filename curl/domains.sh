#!/bin/sh
# Usage: ACCOUNT=account_id TOKEN=token ./domains.sh
#
# Where `account_id` is the numeric ID of the account you are operating on.
curl -i https://api.sandbox.dnsimple.com/v2/${ACCOUNT}/domains -H "Authorization: Bearer ${TOKEN}" -H "Accepts: application/json"
