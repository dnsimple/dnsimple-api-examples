HTTPoison.start
import Dnsimple
client = %Dnsimple.Client{access_token: "bogus", base_url: "https://api.sandbox.dnsimple.com/"}
IO.inspect Dnsimple.IdentityService.whoami(client)
