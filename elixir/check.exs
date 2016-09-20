HTTPoison.start

client = %Dnsimple.Client{access_token: Application.get_env(:dnsimple, :access_token), base_url: "https://api.sandbox.dnsimple.com/"}

{:ok, response} = Dnsimple.Identity.whoami(client)
account_id = response.data.account["id"]

name = Enum.at(System.argv, 0)
IO.puts "Checking #{name}"

IO.inspect Dnsimple.Registrar.check_domain(client, account_id, name)
