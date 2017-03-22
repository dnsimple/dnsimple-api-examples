# Usage: mix run create_contact.exs '{"email":"john.smith@example.com","first_name":"John","last_name":"Smith","address1":"111 SW 1st Street","city":"Miami","state_province":"FL","postal_code":"11111","country":"US","phone":"+1 321 555 4444"}'

client = %Dnsimple.Client{
  access_token: Application.get_env(:dnsimple, :access_token),
  base_url: "https://api.sandbox.dnsimple.com/"
}

{:ok, response} = Dnsimple.Identity.whoami(client)
account_id = response.data.account.id

{:ok, contact} = Poison.Parser.parse(List.last(System.argv))
IO.puts "Create contact #{inspect contact}"

IO.inspect Dnsimple.Contacts.create_contact(client, account_id, contact)

