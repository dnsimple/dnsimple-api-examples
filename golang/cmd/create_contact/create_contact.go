// Usage: TOKEN=token go run cmd/create_contact/create_contact.go '{"email":"john.smith@example.com","first_name":"John","last_name":"Smith","address1":"111 SW 1st Street","city":"Miami","state_province":"FL","postal_code":"11111","country":"US","phone":"+1 321 555 4444"}'
package main

import (
	"encoding/json"
	"fmt"
	"os"
	"strconv"

	"github.com/dnsimple/dnsimple-go/dnsimple"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Printf("Usage: go run cmd/create_contact/create_contact.go '{json}'\n")
		os.Exit(1)
	}

	oauthToken := os.Getenv("TOKEN")
	client := dnsimple.NewClient(dnsimple.NewOauthTokenCredentials(oauthToken))
	client.BaseURL = "https://api.sandbox.dnsimple.com"

	// get the current authenticated account (if you don't know who you are)
	whoamiResponse, err := client.Identity.Whoami()
	if err != nil {
		fmt.Printf("Whoami() returned error: %v\n", err)
		os.Exit(1)
	}

	accountId := strconv.Itoa(whoamiResponse.Data.Account.ID)

	fmt.Printf("Contact data: %v\n", os.Args[1])
	contactData := []byte(os.Args[1])
	fmt.Printf("Contact data as bytes length: %v\n", len(contactData))

	var contact *dnsimple.Contact
	err = json.Unmarshal(contactData, &contact)
	if err != nil {
		fmt.Printf("Error parsing contact JSON: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("Adding contact %v\n", contact)
	createContactResponse, err := client.Contacts.CreateContact(accountId, *contact)
	if err != nil {
		fmt.Printf("CreateContact() returned error: %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("%+v\n", createContactResponse.Data)
}
