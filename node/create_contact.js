'use strict';

// Usage: TOKEN=token node create_contact.js '{"first_name":"John","last_name":"Smith","email":"john@example.com"}'

var client = require('dnsimple')({
  baseUrl: 'https://api.sandbox.dnsimple.com',
  accessToken: process.env.TOKEN,
});

client.identity.whoami().then(function(response) {
  let contact = JSON.parse(process.argv[2]);
  console.log(`Creating contact ${contact.first_name} ${contact.last_name}`);
  return client.contacts.createContact(response.data.account.id, contact);
}).then(function(response) {
  console.log(response);
}, function(error) {
  console.log(error);
});

