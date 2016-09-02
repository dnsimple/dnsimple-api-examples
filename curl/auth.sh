#!/bin/sh
# Usage: TOKEN=token ./auth.sh
curl -i https://api.sandbox.dnsimple.com/v2/whoami -H "Authorization: Bearer ${TOKEN}"
