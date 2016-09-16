'use strict';

var client = require('dnsimple')({
  baseUrl: 'https://api.sandbox.dnsimple.com',
  accessToken: process.env.TOKEN,
});

client.identity.whoami().then(function(response) {
  console.log(response);
}, function(error) {
  console.log(error);
});
