// Usage: TOKEN=token go run cmd/create_domain/create_domain.go example.com 42 code
// where 42 is the contact id that will be used to register the domain and
// code is the authorization code do transfer the domain.
package main

import (
	"context"
	"fmt"
	"os"
	"strconv"

	"github.com/dnsimple/dnsimple-go/v5/dnsimple"
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
	registrantID, _ := strconv.Atoi(os.Args[2])
	authCode := os.Args[3]

	transferRequest := &dnsimple.TransferDomainInput{RegistrantID: registrantID, AuthCode: authCode}

	fmt.Printf("Transferring domain %v\n", name)
	transferDomainResponse, err := client.Registrar.TransferDomain(context.Background(), accountID, name, transferRequest)
	if err != nil {
		fmt.Printf("TransferDomain() returned error: %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("%+v\n", transferDomainResponse.Data)
}
