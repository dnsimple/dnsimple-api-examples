# Usage: mix run transfer_domain.exs example.com 42 code
# where 42 is the registrant id and
# code is the authorization code

client = %Dnsimple.Client{
  access_token: Application.get_env(:dnsimple, :access_token),
  base_url: "https://api.sandbox.dnsimple.com/"
}

{:ok, response} = Dnsimple.Identity.whoami(client)
account_id = response.data.account.id

[name, registrant_id, auth_code] = System.argv

IO.puts "Transferring domain #{name}"

IO.inspect Dnsimple.Registrar.transfer_domain(client, account_id, name, %{registrant_id: registrant_id, auth_code: auth_code})
