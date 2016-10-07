# Usage: mix run create_domain.exs example.com

HTTPoison.start

client = %Dnsimple.Client{
  access_token: Application.get_env(:dnsimple, :access_token),
  base_url: "https://api.sandbox.dnsimple.com/"
}

{:ok, response} = Dnsimple.Identity.whoami(client)
account_id = response.data.account["id"]

name = List.last(System.argv)
IO.puts "Create domain #{name}"

IO.inspect Dnsimple.Domains.create_domain(client, account_id, %{name: name})
