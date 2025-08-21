// Usage: TOKEN=token go run cmd/create_contact/create_contact.go '{"email":"john.smith@example.com","first_name":"John","last_name":"Smith","address1":"111 SW 1st Street","city":"Miami","state_province":"FL","postal_code":"11111","country":"US","phone":"+1 321 555 4444"}'
package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"strconv"

	"github.com/dnsimple/dnsimple-go/v6/dnsimple"
	"golang.org/x/oauth2"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Printf("Usage: go run cmd/create_contact/create_contact.go '{json}'\n")
		os.Exit(1)
	}

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

	// this example only works with account tokens
	// user tokens are perfectly fine, but in order to get the account ID
	// you need to query the method to list all the accounts associated with the user
	// and select one. Account token, instead, uniquely identifies an account.
	if whoamiResponse.Data.User != nil {
		fmt.Printf("You are using an User token, this example only works with Account tokens")
		os.Exit(1)
	}

	accountId := strconv.FormatInt(whoamiResponse.Data.Account.ID, 10)

	contactData := []byte(os.Args[1])

	var contact dnsimple.Contact
	err = json.Unmarshal(contactData, &contact)
	if err != nil {
		fmt.Printf("Error parsing contact JSON: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("Adding contact %v\n", contact)
	createContactResponse, err := client.Contacts.CreateContact(context.Background(), accountId, contact)
	if err != nil {
		fmt.Printf("CreateContact() returned error: %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("%+v\n", createContactResponse.Data)
}
