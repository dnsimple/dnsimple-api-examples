# DNSimple API Golang Examples

The files in this directory demonstrate how to use the DNSimple Golang API wrapper to connect to the DNSimple API.

## Installation

If you are running Go 1.21 or higher, then you should be able to start running examples immediately.

If you are installing an older version, then you will need to run the following:

```shell
go get github.com/dnsimple/dnsimple-go/dnsimple
go get golang.org/x/oauth2
```

## Running

Each directory in `cmd` includes a .go file that can be executed using `go run`. For example:

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
