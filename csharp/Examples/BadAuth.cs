using dnsimple;

namespace DnsimpleExamples.Examples;

// Usage: dotnet run --framework net10.0 -- bad_auth
//
// Note that this example intentionally sends a bogus access token to show
// what happens when authentication fails.
public static class BadAuth
{
    public static void Run(string[] args)
    {
        var client = new Client();
        client.ChangeBaseUrlTo("https://api.sandbox.dnsimple.com");
        client.AddCredentials(new OAuth2Credentials("bogus"));

        // get the current authenticated account (if you don't know who you are)
        try
        {
            var whoami = client.Identity.Whoami().Data;
            Console.WriteLine($"Account: Id={whoami.Account.Id}, Email={whoami.Account.Email}");
        }
        catch (AuthenticationException e)
        {
            // The API responds with a 401 for a bad token, which the client
            // surfaces as an AuthenticationException.
            Console.WriteLine($"Whoami() returned error: {e.Message}");
        }
    }
}
