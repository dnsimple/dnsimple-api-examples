#!/usr/bin/php
<?php
require_once __DIR__.'/../vendor/autoload.php';

// This script assumes a client token. It will work with an account token but the information is not really useful.
// If all you have is a client token, you can run this script, note the account id, and hard code that into
// other scripts where it is supplying an account id from the whoami endpoint.
use Dnsimple\Client;
include "token.php";

// Construct a client instance.
//
// If you want to connect to production, omit the "base_uri" option.
$client = new Client($token, ["base_uri" => "https://api.sandbox.dnsimple.com"]);

// All calls to client pass through a service. In this case, `$client->Identity` is the accounts service.
//
// Dnsimple\Client\Identity->whoami is the method for retrieving the account details for your
// current credentials via the DNSimple API.
$response = $client->Identity->whoami();

// Note:
// $response->getData()->user will be null if an account token was supplied (this examples case)
// $response->getData()->account will be null if a user token was supplied (email/password combination)

// Printing the response and data objects so you can see what's inside.
print_r($response);
print_r($response->getData());
