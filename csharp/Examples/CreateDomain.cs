using dnsimple;
using dnsimple.Services;

namespace DnsimpleExamples.Examples;

// Usage: TOKEN=your-token dotnet run --framework net10.0 -- create_domain example.com
public static class CreateDomain
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
            Console.Error.WriteLine("A domain name argument is required");
            Environment.Exit(1);
        }

        var name = args[0];

        var client = new Client();
        client.ChangeBaseUrlTo("https://api.sandbox.dnsimple.com");
        client.AddCredentials(new OAuth2Credentials(token));

        // get the current authenticated account (if you don't know who you are)
        var accountId = client.Identity.Whoami().Data.Account.Id;

        Console.WriteLine($"Adding domain {name}");

        // add a domain to the account (this does not register the domain,
        // it simply starts hosting it - see the `check`/`transfer_domain`
        // examples for registering/transferring a domain)
        try
        {
            var domain = client.Domains.CreateDomain(accountId, new Domain { Name = name }).Data;
            Console.WriteLine($"Domain: Id={domain.Id}, Name={domain.Name}, State={domain.State}");
        }
        catch (DnsimpleException e)
        {
            Console.Error.WriteLine($"CreateDomain() returned error: {e.Message}");
            Environment.Exit(1);
        }
    }
}
