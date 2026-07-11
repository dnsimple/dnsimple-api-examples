# DNSimple API C# Examples

The files in this directory demonstrate how to use the DNSimple C# API wrapper to connect to the DNSimple API.

## Installation

You need the [.NET 10 SDK](https://dotnet.microsoft.com/download) (LTS) installed. The project multi-targets `net10.0` and `net9.0`, and the .NET 10 SDK can build and run both.

Restore the [DNSimple](https://www.nuget.org/packages/DNSimple) NuGet package:

```shell
dotnet restore
```

## Running

Each command lives in its own file under `Examples/` and is dispatched from `Program.cs` by name. Because the project multi-targets, pass the framework you want to run on. For example:

```shell
TOKEN=your-token dotnet run --framework net10.0 -- auth
```

To run commands that require additional arguments:

```shell
TOKEN=your-token dotnet run --framework net10.0 -- check example.com
```

Substitute `net9.0` to run on .NET 9.

Running with no arguments (or an unknown command) prints usage and the list of available commands.

**Unless otherwise noted**, all examples expect a working [Sandbox DNSimple](https://developer.dnsimple.com/sandbox/) account token, and connect to `https://api.sandbox.dnsimple.com`. Some examples (e.g. `create_contact`) only work with Account tokens: a User token is valid, but you would first need to look up which account to use via the accounts list, since a User token is not tied to a single account.

Consult the code for each example for additional argument requirements.

## Available commands

* `auth` - retrieve the current authenticated whoami (account and/or user)
* `bad_auth` - demonstrate the error raised when authentication fails
* `account_list` - list the accounts accessible to a User token
* `check example.com` - check whether a domain name is available for registration
* `domains` - list the domains in the account
* `create_domain example.com` - add a domain to the account
* `create_contact '{json}'` - create a contact, to be used later as a registrant
* `zone_records example.com` - list the records for a zone
* `domain_transfers example.com 42` - retrieve the details of a domain transfer
* `transfer_domain example.com 42 code` - transfer a domain in from another registrar
* `cancel_domain_transfer example.com 42` - cancel an in progress domain transfer
* `tld_extended_attributes uk` - list the extended attributes required for a TLD
