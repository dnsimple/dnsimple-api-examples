using dnsimple;
using dnsimple.Services;
using Newtonsoft.Json;

namespace DnsimpleExamples.Examples;

// Usage: TOKEN=your-token dotnet run --framework net10.0 -- create_contact '{"email":"john.smith@example.com","first_name":"John","last_name":"Smith","address1":"111 SW 1st Street","city":"Miami","state_province":"FL","postal_code":"11111","country":"US","phone":"+1 321 555 4444"}'
public static class CreateContact
{
    public static void Run(string[] args)
    {
        if (args.Length != 1)
        {
            Console.Error.WriteLine("Usage: dotnet run --framework net10.0 -- create_contact '{json}'");
            Environment.Exit(1);
        }

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
        var whoami = client.Identity.Whoami().Data;

        // this example only works with account tokens; user tokens are
        // perfectly fine, but in order to get the account ID you need to
        // query the method to list all the accounts associated with the
        // user and select one. An account token, instead, uniquely
        // identifies an account.
        if (whoami.Account.Id == 0)
        {
            Console.Error.WriteLine("You are using a User token, this example only works with Account tokens");
            Environment.Exit(1);
        }

        var accountId = whoami.Account.Id;

        Contact contact;
        try
        {
            contact = JsonConvert.DeserializeObject<Contact>(args[0]);
        }
        catch (JsonException e)
        {
            Console.Error.WriteLine($"Error parsing contact JSON: {e.Message}");
            Environment.Exit(1);
            return;
        }

        Console.WriteLine($"Adding contact {contact.FirstName} {contact.LastName}");

        // create the contact in the account, used later to register or
        // transfer domains
        try
        {
            var created = client.Contacts.CreateContact(accountId, contact).Data;
            Console.WriteLine($"Contact: Id={created.Id}, Email={created.Email}");
        }
        catch (DnsimpleException e)
        {
            Console.Error.WriteLine($"CreateContact() returned error: {e.Message}");
            Environment.Exit(1);
        }
    }
}
