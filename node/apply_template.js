const { DNSimple, AuthenticationError } = require('dnsimple');

(async () => {
  const dnsimple = new DNSimple({
    baseUrl: 'https://api.sandbox.dnsimple.com',
    accessToken: process.env.TOKEN,
    userAgent: 'dnsimple-examples',
  });

  try {
    const identity = await dnsimple.identity.whoami();
    const accountId = identity.data.account.id;
    const domainName = process.env.DOMAIN;
    const templateId = process.env.templateID;

    if (!domainName) {
      console.error('Please specify a domain name to register');
      return;
    }

    if (!templateId) {
      console.error('Please specify a template ID to register the domain with');
      return;
    }

    const response = await dnsimple.templates.applyTemplate(accountId, domainName, templateId);
    console.log(response);
  } catch (err) {
    if (err instanceof AuthenticationError) {
      console.error('Authentication error. Check your token is correct for the sandbox environment.');
    } else {
      console.error(err);
    }
  }
})();
