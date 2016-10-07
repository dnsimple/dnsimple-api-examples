'use strict';

// Usage: TOKEN=token node zone_records.js example.com

var client = require('dnsimple')({
  baseUrl: 'https://api.sandbox.dnsimple.com',
  accessToken: process.env.TOKEN,
});

client.identity.whoami().then(function(response) {
  let name = process.argv[2];
  return client.zones.listZoneRecords(response.data.account.id, name);
}).then(function(response) {
  console.log(response);
}, function(error) {
  console.log(error);
});

