'use strict';

// Usage: TOKEN=token node create_domain.js

var client = require('dnsimple')({
  baseUrl: 'https://api.sandbox.dnsimple.com',
  accessToken: process.env.TOKEN,
});

client.identity.whoami().then(function(response) {
  let name = process.argv[2];
  console.log(`Creating domain ${name}`);
  return client.domains.createDomain(response.data.account.id, {name: name});
}).then(function(response) {
  console.log(response);
}, function(error) {
  console.log(error);
});
