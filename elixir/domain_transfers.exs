# Usage: mix run domain_transfers.exs example.com 42
# where 42 is the domain transfer id

client = %Dnsimple.Client{
  access_token: Application.get_env(:dnsimple, :access_token),
  base_url: "https://api.sandbox.dnsimple.com/"
}

{:ok, response} = Dnsimple.Identity.whoami(client)
account_id = response.data.account.id

[name, transfer_id] = System.argv

IO.puts "Getting Transfer #{transfer_id} for domain #{name}"

IO.inspect Dnsimple.Registrar.get_domain_transfer(client, account_id, name, transfer_id)
