'use strict';

// Usage: TOKEN=token node cancel_domain_transfer.js example.com 42
// where 42 is the domain transfer id

var client = require('dnsimple')({
  baseUrl: 'https://api.sandbox.dnsimple.com',
  accessToken: process.env.TOKEN,
});

client.identity.whoami().then(function (response) {
  let name = process.argv[2];
  let transferId = process.argv[3]
  console.log(`Cancelling transfer ${transferId} for domain ${name}`);
  return client.registrar.cancelDomainTransfer(response.data.account.id, name, transferId);
}).then(function (response) {
  console.log(response);
}, function (error) {
  console.log(error);
});
