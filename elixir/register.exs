# Usage: mix run register.exs example.com

client = %Dnsimple.Client{access_token: Application.get_env(:dnsimple, :access_token), base_url: "https://api.sandbox.dnsimple.com/"}

{:ok, response} = Dnsimple.Identity.whoami(client)
account_id = response.data.account.id

{:ok, response} = Dnsimple.Contacts.list_contacts(client, account_id)
[registrant | _] = response.data

name = Enum.at(System.argv, 0)

IO.inspect Dnsimple.Registrar.register_domain(client, account_id, name, %{
  registrant_id: registrant.id,
  auto_renew: 0,
  privacy: 0,
})
