const { DNSimple, AuthenticationError } = require('dnsimple');

(async () => {
  const dnsimple = new DNSimple({
    baseUrl: 'https://api.sandbox.dnsimple.com',
    accessToken: process.env.TOKEN,
    userAgent: 'dnsimple-examples',
  });

  try {
    let identity = await dnsimple.identity.whoami();
    const accountID = identity.data.account.id;
    const domainName = process.env.DOMAIN;
    const templateID = process.env.templateID;

    if (!domainName) {
      console.error('Please specify a domain name to register');
      return;
    }

    if (!templateID) {
      console.error('Please specify a template ID to register the domain with');
      return;
    }

    const response = await dnsimple.templates.applyTemplate(accountID, domainName, templateID);

    console.log(response);
  } catch (err) {
    if (err instanceof AuthenticationError) {
      console.error('Authentication error. Check your token is correct for the sandbox environment.');
    } else {
      console.error(err);
    }
  }
})();
