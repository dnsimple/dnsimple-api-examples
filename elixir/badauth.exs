# Usage: mix run badauth.exs

Dnsimple.start

client = %Dnsimple.Client{access_token: "bogus", base_url: "https://api.sandbox.dnsimple.com/"}
IO.inspect Dnsimple.Identity.whoami(client)
