# Usage: mix run zone_record.exs example.com

Dnsimple.start

client = %Dnsimple.Client{access_token: Application.get_env(:dnsimple, :access_token), base_url: "https://api.sandbox.dnsimple.com/"}

# Grabs the first account based on your user token
account = case Dnsimple.Accounts.accounts(client) do
  {:ok, response} -> List.first(response.data)
  {:error, error} -> raise RuntimeError, message: error.message
end

# Grabs the first zone on this account
zone = case Dnsimple.Zones.zones(client, account.id) do
  {:ok, response} -> List.first(response.data)
  {:error, error} -> raise RuntimeError, message: error.message
end

# List all the DNS records for this domain
case Dnsimple.Zones.records(client, account.id, zone.name) do
  {:ok, response} -> IO.inspect response.data
  {:error, error} -> raise RuntimeError, message: error.message
end
