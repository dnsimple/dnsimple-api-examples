using dnsimple;

namespace DnsimpleExamples.Examples;

// Usage: TOKEN=your-token dotnet run --framework net10.0 -- domains
public static class Domains
{
    public static void Run(string[] args)
    {
        var token = Environment.GetEnvironmentVariable("TOKEN");
        if (string.IsNullOrEmpty(token))
        {
            Console.Error.WriteLine("The TOKEN environment variable is required");
            Environment.Exit(1);
        }

        var client = new Client();
        client.ChangeBaseUrlTo("https://api.sandbox.dnsimple.com");
        client.AddCredentials(new OAuth2Credentials(token));

        // get the current authenticated account (if you don't know who you are)
        var accountId = client.Identity.Whoami().Data.Account.Id;

        // list the domains in the account
        try
        {
            var domains = client.Domains.ListDomains(accountId).Data;
            foreach (var domain in domains)
            {
                Console.WriteLine($"Domain: Id={domain.Id}, Name={domain.Name}, State={domain.State}, ExpiresAt={domain.ExpiresAt}");
            }
        }
        catch (DnsimpleException e)
        {
            Console.Error.WriteLine($"ListDomains() returned error: {e.Message}");
            Environment.Exit(1);
        }
    }
}
