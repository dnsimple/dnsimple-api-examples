// Usage: TOKEN=token go run cmd/cancel_domain_transfer/cancel_domain_transfer.go example.com 42
// where 42 is the domain transfer id
package main

import (
	"context"
	"fmt"
	"os"
	"strconv"

	"github.com/dnsimple/dnsimple-go/v6/dnsimple"
	"golang.org/x/oauth2"
)

func main() {
	oauthToken := os.Getenv("TOKEN")
	ts := oauth2.StaticTokenSource(&oauth2.Token{AccessToken: oauthToken})
	tc := oauth2.NewClient(context.Background(), ts)

	client := dnsimple.NewClient(tc)
	client.BaseURL = "https://api.sandbox.dnsimple.com"

	// get the current authenticated account (if you don't know who you are)
	whoamiResponse, err := client.Identity.Whoami(context.Background())
	if err != nil {
		fmt.Printf("Whoami() returned error: %v\n", err)
		os.Exit(1)
	}

	accountID := strconv.FormatInt(whoamiResponse.Data.Account.ID, 10)

	fmt.Printf("account id %v\n", accountID)

	name := os.Args[1]
	transferID, _ := strconv.ParseInt(os.Args[2], 0, 64)

	fmt.Printf("Cancelling Transfer %v for %v\n", transferID, name)
	cancelDomainTransferResponse, err := client.Registrar.CancelDomainTransfer(context.Background(), accountID, name, transferID)
	if err != nil {
		fmt.Printf("CancelDomainTransfer() returned error: %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("%+v\n", cancelDomainTransferResponse.Data)
}
