// Usage: TOKEN=token go run cmd/domains/domains.go
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

	accountId := strconv.FormatInt(whoamiResponse.Data.Account.ID, 10)

	domainsResponse, err := client.Domains.ListDomains(context.Background(), accountId, nil)
	if err != nil {
		fmt.Printf("ListDomains() returned error: %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("%+v\n", domainsResponse)
}
