using dnsimple;

namespace DnsimpleExamples.Examples;

// Usage: TOKEN=your-token dotnet run --framework net10.0 -- account_list
//
// This example only works with a User token: an Account token already
// uniquely identifies a single account, so listing accounts is only
// meaningful when you authenticated as a user with access to many.
public static class AccountList
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

        // list the accounts the current authenticated entity has access to
        try
        {
            var accounts = client.Accounts.List().Data;
            foreach (var account in accounts)
            {
                Console.WriteLine($"Account: Id={account.Id}, Email={account.Email}, Plan={account.PlanIdentifier}");
            }
        }
        catch (DnsimpleException e)
        {
            Console.Error.WriteLine($"Accounts.List() returned error: {e.Message}");
            Environment.Exit(1);
        }
    }
}
