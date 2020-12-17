'use strict';

// Usage: TOKEN=token node transfer_domain.js example.com auth_code:test registrant_id:42

var client = require('dnsimple')({
  baseUrl: 'https://api.sandbox.dnsimple.com',
  accessToken: process.env.TOKEN,
});

client.identity.whoami().then(function (response) {
  let name = process.argv[2];
  let attributes = process.argv.slice(3).reduce((obj, val) => ({ ...obj, [val.split(':')[0]]: val.split(':')[1] }), {})
  console.log(`Transferring domain ${name} with ${JSON.stringify(attributes)} attributes`);
  return client.registrar.transferDomain(response.data.account.id, name, attributes);
}).then(function (response) {
  console.log(response);
}, function (error) {
  console.log(error);
});
