using dnsimple;

namespace DnsimpleExamples.Examples;

// Usage: TOKEN=your-token dotnet run -- zone_records example.com
public static class ZoneRecords
{
    public static void Run(string[] args)
    {
        var token = Environment.GetEnvironmentVariable("TOKEN");
        if (string.IsNullOrEmpty(token))
        {
            Console.Error.WriteLine("The TOKEN environment variable is required");
            Environment.Exit(1);
        }

        if (args.Length < 1)
        {
            Console.Error.WriteLine("A zone name argument is required");
            Environment.Exit(1);
        }

        var zoneId = args[0];

        var client = new Client();
        client.ChangeBaseUrlTo("https://api.sandbox.dnsimple.com");
        client.AddCredentials(new OAuth2Credentials(token));

        // get the current authenticated account (if you don't know who you are)
        var accountId = client.Identity.Whoami().Data.Account.Id;

        // list the records for the zone
        try
        {
            var records = client.Zones.ListZoneRecords(accountId, zoneId).Data;
            foreach (var record in records)
            {
                Console.WriteLine($"Record: Id={record.Id}, Name={record.Name}, Type={record.Type}, Content={record.Content}, Ttl={record.Ttl}");
            }
        }
        catch (DnsimpleException e)
        {
            Console.Error.WriteLine($"ListZoneRecords() returned error: {e.Message}");
            Environment.Exit(1);
        }
    }
}
