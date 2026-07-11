using dnsimple;
using dnsimple.Services;

namespace DnsimpleExamples.Examples;

// Usage: TOKEN=your-token dotnet run -- transfer_domain example.com 42 code
// where 42 is the contact id that will be used as the registrant and code
// is the authorization code needed to transfer the domain.
public static class TransferDomain
{
    public static void Run(string[] args)
    {
        var token = Environment.GetEnvironmentVariable("TOKEN");
        if (string.IsNullOrEmpty(token))
        {
            Console.Error.WriteLine("The TOKEN environment variable is required");
            Environment.Exit(1);
        }

        if (args.Length < 3 || !long.TryParse(args[1], out var registrantId))
        {
            Console.Error.WriteLine("Usage: dotnet run -- transfer_domain <domain-name> <registrant-contact-id> <auth-code>");
            Environment.Exit(1);
            return;
        }

        var name = args[0];
        var authCode = args[2];

        var client = new Client();
        client.ChangeBaseUrlTo("https://api.sandbox.dnsimple.com");
        client.AddCredentials(new OAuth2Credentials(token));

        // get the current authenticated account (if you don't know who you are)
        var accountId = client.Identity.Whoami().Data.Account.Id;

        Console.WriteLine($"account id {accountId}");
        Console.WriteLine($"Transferring domain {name}");

        var transferInput = new DomainTransferInput { RegistrantId = registrantId, AuthCode = authCode };

        // transfer a domain name in from another registrar
        try
        {
            var transfer = client.Registrar.TransferDomain(accountId, name, transferInput).Data;
            Console.WriteLine($"Transfer: Id={transfer.Id}, DomainId={transfer.DomainId}, State={transfer.State}");
        }
        catch (DnsimpleException e)
        {
            Console.Error.WriteLine($"TransferDomain() returned error: {e.Message}");
            Environment.Exit(1);
        }
    }
}
