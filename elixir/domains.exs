# Usage: mix run domains.exs

Dnsimple.start

client = %Dnsimple.Client{access_token: Application.get_env(:dnsimple, :access_token), base_url: "https://api.sandbox.dnsimple.com/"}

{:ok, response} = Dnsimple.Identity.whoami(client)
account_id = response.data.account["id"]

IO.inspect Dnsimple.Domains.list_domains(client, account_id)
