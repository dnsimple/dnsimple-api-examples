#!/usr/bin/php
<?php
require_once __DIR__.'/../vendor/autoload.php';

// This script assumes a client token. It will work with an account token but the information is not really useful.
// If all you have is a client token, you can run this script, note the account id, and hard code that into
// other scripts where it is supplying an account id from the whoami endpoint.
use Dnsimple\Client;

// Construct a client instance.
//
// If you want to connect to production, omit the "base_uri" option.
$client = new Client("fake", ["base_uri" => "https://api.sandbox.dnsimple.com"]);

// All calls to client pass through a service. In this case, `$client->Identity` is the accounts service.
//
// Dnsimple\Client\Identity->whoami is the method for retrieving the account details for your
// current credentials via the DNSimple API.
//
// In this case the call with fail raising an exception.
$response = $client->identity->whoami();
