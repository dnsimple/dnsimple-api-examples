// Usage: TOKEN=your-token dotnet run -- <command> [args...]
//
// Each command below corresponds to one example under Examples/, mirroring
// the examples found in the other language directories in this repository.
using DnsimpleExamples.Examples;

var commands = new Dictionary<string, Action<string[]>>
{
    ["auth"] = Auth.Run,
    ["bad_auth"] = BadAuth.Run,
    ["account_list"] = AccountList.Run,
    ["check"] = Check.Run,
    ["domains"] = Domains.Run,
    ["create_domain"] = CreateDomain.Run,
    ["create_contact"] = CreateContact.Run,
    ["zone_records"] = ZoneRecords.Run,
    ["domain_transfers"] = DomainTransfers.Run,
    ["transfer_domain"] = TransferDomain.Run,
    ["cancel_domain_transfer"] = CancelDomainTransfer.Run,
    ["tld_extended_attributes"] = TldExtendedAttributes.Run,
};

if (args.Length == 0 || !commands.TryGetValue(args[0], out var command))
{
    Console.Error.WriteLine("Usage: TOKEN=your-token dotnet run -- <command> [args...]");
    Console.Error.WriteLine();
    Console.Error.WriteLine("Available commands:");
    foreach (var name in commands.Keys.OrderBy(n => n, StringComparer.Ordinal))
    {
        Console.Error.WriteLine($"  {name}");
    }
    return 1;
}

command(args.Skip(1).ToArray());
return 0;
