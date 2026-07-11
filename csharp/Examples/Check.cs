using dnsimple;

namespace DnsimpleExamples.Examples;

// Usage: TOKEN=your-token dotnet run -- check example.com
public static class Check
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

        var domainName = args[0];

        var client = new Client();
        client.ChangeBaseUrlTo("https://api.sandbox.dnsimple.com");
        client.AddCredentials(new OAuth2Credentials(token));

        // get the current authenticated account (if you don't know who you are)
        var accountId = client.Identity.Whoami().Data.Account.Id;

        // check whether a domain name is available for registration
        try
        {
            var check = client.Registrar.CheckDomain(accountId, domainName).Data;
            Console.WriteLine($"Domain: {check.Domain}, Available={check.Available}, Premium={check.Premium}");
        }
        catch (DnsimpleException e)
        {
            Console.Error.WriteLine($"CheckDomain() returned error: {e.Message}");
            Environment.Exit(1);
        }
    }
}
