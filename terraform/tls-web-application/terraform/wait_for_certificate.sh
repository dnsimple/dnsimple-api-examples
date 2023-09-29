#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <token> <account_id> <domain> <certificate_id>"
    exit 1
fi

token=$1
account_id=$2
domain=$3
certificate_id=$4

desired_state="issued"
timeout=600  # Set a timeout (e.g., 600 seconds = 10 minutes)
interval=30  # Check every 30 seconds

end_time=$(( $(date +%s) + $timeout ))

while [ $(date +%s) -lt $end_time ]; do
    response=$(curl \
      -H "Authorization: Bearer $token" \
      -H "Accept: application/json" \
      "https://api.dnsimple.com/v2/$account_id/domains/$domain/certificates/$certificate_id")

    # Extract the state value using jq
    current_state=$(echo $response | jq -r .data.state)

    if [ "$current_state" == "$desired_state" ]; then
        sleep 10 # Avoid race condition where the certificate has been issued but is not available for download
        exit 0
    fi

    sleep $interval
done

echo "Timeout waiting for certificate to be issued."
exit 1
