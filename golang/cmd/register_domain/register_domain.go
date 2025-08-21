// Usage: TOKEN=token go run cmd/register_domain/register_domain.go example.com
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

	accountId := strconv.FormatInt(whoamiResponse.Data.Account.ID, 10)

	domainName := os.Args[1]
	fmt.Printf("Registering domain %v\n", domainName)
	contacts, err := client.Contacts.ListContacts(context.Background(), accountId, nil)

	if err != nil {
		fmt.Printf("ListContacts() returned error: %v\n", err)
		os.Exit(1)
	}

	if len(contacts.Data) == 0 {
		fmt.Printf("ListContacts() returned no contacts. Please create first a contact.")
		os.Exit(1)
	}

	contact := contacts.Data[0]

	registerDomainResponse, err := client.Registrar.RegisterDomain(context.Background(), accountId, domainName, &dnsimple.RegisterDomainInput{RegistrantID: int(contact.ID)})
	if err != nil {
		fmt.Printf("RegisterDomain() returned error: %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("%+v\n", registerDomainResponse.Data)
}
