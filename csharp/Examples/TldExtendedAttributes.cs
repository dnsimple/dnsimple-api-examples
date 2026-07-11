using dnsimple;

namespace DnsimpleExamples.Examples;

// Usage: TOKEN=your-token dotnet run -- tld_extended_attributes uk
public static class TldExtendedAttributes
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
            Console.Error.WriteLine("A TLD argument is required");
            Environment.Exit(1);
        }

        var tld = args[0];

        var client = new Client();
        client.ChangeBaseUrlTo("https://api.sandbox.dnsimple.com");
        client.AddCredentials(new OAuth2Credentials(token));

        // no account is required for this call, it is not account-scoped

        // list the extended attributes required to register/transfer a
        // domain under this TLD (e.g. many ccTLDs require these)
        try
        {
            var attributes = client.Tlds.GetTldExtendedAttributes(tld).Data;
            if (attributes.Count == 0)
            {
                Console.WriteLine($"The TLD {tld} does not require any extended attributes");
                return;
            }

            foreach (var attribute in attributes)
            {
                Console.WriteLine($"Attribute: Name={attribute.Name}, Description={attribute.Description}, Required={attribute.Required}");
            }
        }
        catch (DnsimpleException e)
        {
            Console.Error.WriteLine($"GetTldExtendedAttributes() returned error: {e.Message}");
            Environment.Exit(1);
        }
    }
}
