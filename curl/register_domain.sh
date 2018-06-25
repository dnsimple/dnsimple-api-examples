# Usage: TOKEN=token ./register_domain.sh account_id domain_name attributes
# 
# Where `account_id` is the numeric ID of the account you are operating on, `domain_name` is
# the name you are registering, and `attributes` is a JSON structure representing the registration
# attributes.
# 
# For example:
# 
# `TOKEN=token ./register_domain.sh 111 example.co.uk '{"registrant_id":"111","extended_attributes":{"uk_legal_type":"FIND","registered_for":"Your Name"}}}'
curl -i "https://api.sandbox.dnsimple.com/v2/$1/registrar/domains/$2/registrations" -H "Authorization: Bearer ${TOKEN}" -H "Accepts: application/json" -H "Content-Type: application/json" -X POST -d "$3"
