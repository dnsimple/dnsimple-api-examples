#!/bin/sh
# Usage: TOKEN=token ./apply_template.sh account_id domain_name template_id
#
# Where `account_id` is the numeric ID of the account you are operating on
# `domain_name` is the domain name and `template_id` is the short name or the
# numeric ID of the template from the account.
#
# For example:
# 
# `./apply_template.sh 111 example.com template
curl -i "https://api.sandbox.dnsimple.com/v2/$1/domains/$2/templates/$3" -H "Authorization: Bearer ${TOKEN}" -H "Accepts: application/json" -X POST
