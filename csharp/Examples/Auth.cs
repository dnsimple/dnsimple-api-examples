using dnsimple;

namespace DnsimpleExamples.Examples;

// Usage: TOKEN=your-token dotnet run -- auth
public static class Auth
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
        try
        {
            var whoami = client.Identity.Whoami().Data;

            // Note:
            //     Account.Id will be 0 if you authenticated with a User token
            //     User.Id will be 0 if you authenticated with an Account token
            Console.WriteLine($"Account: Id={whoami.Account.Id}, Email={whoami.Account.Email}, Plan={whoami.Account.PlanIdentifier}");
            Console.WriteLine($"User: Id={whoami.User.Id}, Email={whoami.User.Email}");
        }
        catch (DnsimpleException e)
        {
            Console.Error.WriteLine($"Whoami() returned error: {e.Message}");
            Environment.Exit(1);
        }
    }
}
