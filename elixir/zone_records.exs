# Usage: mix run zone_record.exs example.com

Dnsimple.start

client = %Dnsimple.Client{
  access_token: Application.get_env(:dnsimple, :access_token),
  base_url: "https://api.sandbox.dnsimple.com/"
}

# Grabs the first account based on your user token
account = case Dnsimple.Identity.whoami(client) do
  {:ok, response} -> response.data.account
  {:error, error} -> raise RuntimeError, message: error.message
end

name = List.last(System.argv)

# List all the DNS records for the given domain
case Dnsimple.Zones.list_zone_records(client, account["id"], name) do
  {:ok, response} -> IO.inspect response.data
  {:error, error} -> raise RuntimeError, message: error.message
end
