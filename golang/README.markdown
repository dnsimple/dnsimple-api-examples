# DNSimple API Golang Examples

The files in this directory demonstrate how to use the DNSimple Golang API wrapper to connect to the DNSimple API.

## Installation

```shell
go get github.com/dnsimple/dnsimple-go/dnsimple
```

## Running

Each directory in `cmd` includes a .go file that can be executed. For example:

```shell
go run cmd/badauth/badauth.go
```

To run commands with the token:

```shell
TOKEN=your-token go run cmd/auth/auth.go
```

Some commands require additional command line arguments. For example:

```shell
TOKEN=your-token go run cmd/check/check.go example.com
```

Consult the code for each example for additional argument requirements.
