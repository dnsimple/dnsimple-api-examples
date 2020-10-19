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
//
// The response object returned by any API method includes a `data` attribute. Underneath that
// attribute is an attribute for each data object returned. In this case, `account`, provides
// access to the resulting account object.
//
// There the account ID is extracted for use in future calls.
$accountId = $client->identity->whoami()->getData()->account->id;

// Dnsimple\Client\Registrar->checkDomain is the method for checking the availability for a domain name.
// It expects the account ID and the domain name to check to be passed as arguments.
//
// In this case we are taking the first argument passed into the call `php check.php google.com`.
$response = $client->registrar->checkDomain($accountId, $argv[1]);

// Printing the response and data objects so you can see what's inside.
print_r($response);
print_r($response->getData());
