HTTPoison.start
import Dnsimple
client = %Dnsimple.Client{access_token: Application.get_env(:dnsimple, :access_token), base_url: "https://api.sandbox.dnsimple.com/"}
IO.inspect Dnsimple.IdentityService.whoami(client)
