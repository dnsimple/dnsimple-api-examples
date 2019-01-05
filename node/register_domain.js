'use strict';

// Usage: TOKEN=token CONTACT_ID=1 node register_domain.js example.com

var client = require('dnsimple')({
  baseUrl: 'https://api.sandbox.dnsimple.com',
  accessToken: process.env.TOKEN,
});

client.identity.whoami().then(function(response) {
  let name = process.argv[2];
  let attributes = { registrant_id: process.env.CONTACT_ID, auto_renew: true }

  console.log(`Registering domain ${name}`);
  return client.registrar.registerDomain(response.data.account.id, name, attributes);
}).then(function(response) {
  console.log(response);
}, function(error) {
  console.log(error);
});
