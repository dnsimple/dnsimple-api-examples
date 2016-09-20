'use strict';

// Usage: TOKEN=token node check.js example.com

var client = require('dnsimple')({
  baseUrl: 'https://api.sandbox.dnsimple.com',
  accessToken: process.env.TOKEN,
});

client.identity.whoami().then(function(response) {
  return client.registrar.checkDomain(response.data.account.id, process.argv[2]);
}).then(function(response) {
  console.log(response);
}, function(error) {
  console.log(error);
});
