'use strict';

var client = require('dnsimple')({
  baseUrl: 'https://api.sandbox.dnsimple.com',
});

client.identity.whoami().then(function(response) {
  console.log(response);
}, function(error) {
  console.log(error);
});
