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
$accountId = $client->Identity->whoami()->getData()->account->id;

// These are the attributes needed to create a contact. Please feel free to modify the values when
// you are testing this by yourself.
$attributes = [
    "first_name" => "First",
    "last_name" => "User",
    "address1" => "Italian Street, 10",
    "city" => "Roma",
    "state_province" => "RM",
    "postal_code" => "00100",
    "country" => "IT",
    "email" => "first@example.com",
    "phone" => "+18001234567"
];

// DNSimple\Client\Contacts->createContact is the method used to create a new contact.
//
// It expects the account ID and a array containing the key/value pairs with the data needed
// to create the contact.
$response = $client->Contacts->createContact($accountId, $attributes);

// Printing the response and data objects so you can see what's inside.
print_r($response);
print_r($response->getData());
