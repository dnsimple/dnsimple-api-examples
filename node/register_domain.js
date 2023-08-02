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
    const contactId = process.env.CONTACT_ID;

    if (!domainName) {
      console.error('Please specify a domain name to register');
      return;
    }

    if (!contactId) {
      console.error('Please specify a contact ID to register the domain with');
      return;
    }

    const registrationAttributes = { registrant_id: contactId, auto_renew: true };
    const registration = await dnsimple.registrar.registerDomain(accountId, domainName, registrationAttributes);
    console.log(registration);
  } catch (err) {
    if (err instanceof AuthenticationError) {
      console.error('Authentication error. Check your token is correct for the sandbox environment.');
    } else {
      console.error(err);
    }
  }
})();
