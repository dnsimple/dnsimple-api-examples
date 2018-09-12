// Usage: TOKEN=token go run cmd/zone_records/zone_records.go example.com
package main

import (
	"context"
	"fmt"
	"os"
	"strconv"

	"github.com/dnsimple/dnsimple-go/dnsimple"
	"golang.org/x/oauth2"
)

func main() {
	oauthToken := os.Getenv("TOKEN")
	ts := oauth2.StaticTokenSource(&oauth2.Token{AccessToken: oauthToken})
	tc := oauth2.NewClient(context.Background(), ts)

	client := dnsimple.NewClient(tc)
	client.BaseURL = "https://api.sandbox.dnsimple.com"

	// get the current authenticated account (if you don't know who you are)
	whoamiResponse, err := client.Identity.Whoami()
	if err != nil {
		fmt.Printf("Whoami() returned error: %v\n", err)
		os.Exit(1)
	}

	accountId := strconv.Itoa(whoamiResponse.Data.Account.ID)

	listZoneRecordsResponse, err := client.Zones.ListRecords(accountId, os.Args[1], nil)
	if err != nil {
		fmt.Printf("ListRecords() returned error: %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("%+v\n", listZoneRecordsResponse)
}
