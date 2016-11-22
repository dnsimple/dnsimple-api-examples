'use strict';

// Usage: TOKEN=token node apply_template.js example.com template
//
// The template value may be either the template short name or the template numeric ID

var client = require('dnsimple')({
  baseUrl: 'https://api.sandbox.dnsimple.com',
  accessToken: process.env.TOKEN,
});

client.identity.whoami().then(function(response) {
  let name = process.argv[2];
  let templateId = process.argv[3];
  return client.templates.applyTemplate(response.data.account.id, templateId, name);
}).then(function(response) {
  console.log(response);
}, function(error) {
  console.log(error);
});


