# DNSimple API C# Examples

The files in this directory demonstrate how to use the DNSimple C# API wrapper to connect to the DNSimple API.

## Installation

You need the [.NET 9 SDK](https://dotnet.microsoft.com/download) or higher installed.

Restore the [DNSimple](https://www.nuget.org/packages/DNSimple) NuGet package:

```shell
dotnet restore
```

## Running

Each command lives in its own file under `Examples/` and is dispatched from `Program.cs` by name. For example:

```shell
TOKEN=your-token dotnet run -- auth
```

To run commands that require additional arguments:

```shell
TOKEN=your-token dotnet run -- check example.com
```

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
