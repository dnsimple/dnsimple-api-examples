var client = require('dnsimple')({
  baseUrl: 'https://api.sandbox.dnsimple.com',
});

client.identity.whoami(function(error, response) {
  console.log(response);
});
