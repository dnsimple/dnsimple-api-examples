package main

import (
	"fmt"
	"os"

	"github.com/dnsimple/dnsimple-go/dnsimple"
)

func main() {
	oauthToken := os.Getenv("TOKEN")
	client := dnsimple.NewClient(dnsimple.NewOauthTokenCredentials(oauthToken))
	client.BaseURL = "https://api.sandbox.dnsimple.com"

	// get the current authenticated account (if you don't know who you are)
	whoamiResponse, err := client.Identity.Whoami()
	if err != nil {
		fmt.Printf("Whoami() returned error: %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("%+v\n", whoamiResponse)
	fmt.Printf("%+v\n", whoamiResponse.Data.Account)
}
