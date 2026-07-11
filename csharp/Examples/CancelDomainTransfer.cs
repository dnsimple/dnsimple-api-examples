using dnsimple;

namespace DnsimpleExamples.Examples;

// Usage: TOKEN=your-token dotnet run --framework net10.0 -- cancel_domain_transfer example.com 42
// where 42 is the domain transfer id
public static class CancelDomainTransfer
{
    public static void Run(string[] args)
    {
        var token = Environment.GetEnvironmentVariable("TOKEN");
        if (string.IsNullOrEmpty(token))
        {
            Console.Error.WriteLine("The TOKEN environment variable is required");
            Environment.Exit(1);
        }

        if (args.Length < 2 || !long.TryParse(args[1], out var transferId))
        {
            Console.Error.WriteLine("Usage: dotnet run --framework net10.0 -- cancel_domain_transfer <domain-name> <transfer-id>");
            Environment.Exit(1);
            return;
        }

        var name = args[0];

        var client = new Client();
        client.ChangeBaseUrlTo("https://api.sandbox.dnsimple.com");
        client.AddCredentials(new OAuth2Credentials(token));

        // get the current authenticated account (if you don't know who you are)
        var accountId = client.Identity.Whoami().Data.Account.Id;

        Console.WriteLine($"account id {accountId}");
        Console.WriteLine($"Cancelling transfer {transferId} for {name}");

        // cancel an in progress domain transfer
        try
        {
            var transfer = client.Registrar.CancelDomainTransfer(accountId, name, transferId).Data;
            Console.WriteLine($"Transfer: Id={transfer.Id}, DomainId={transfer.DomainId}, State={transfer.State}");
        }
        catch (DnsimpleException e)
        {
            Console.Error.WriteLine($"CancelDomainTransfer() returned error: {e.Message}");
            Environment.Exit(1);
        }
    }
}
