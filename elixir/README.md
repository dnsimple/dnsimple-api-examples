# Dnsimple API Elixir Example

## Installing

Get dependencies:

```
mix deps.get
```

## Configuring

Create a file `config/token.exs` and put the following into that file, replacing `your-token` with a user token generated from the DNSimple Sandbox site:

```elixir
use Mix.Config

config :dnsimple,
  access_token: "your-token"
```


## Running

Run individual scripts:

```
mix run badauth.exs
```
