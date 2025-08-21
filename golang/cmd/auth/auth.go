// Usage: TOKEN=token go run cmd/auth/auth.go
package main

import (
	"context"
	"fmt"
	"os"

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
	fmt.Printf("%+v\n", whoamiResponse)
	fmt.Printf("%+v\n", whoamiResponse.Data.Account)
}
