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
    const contactID = process.env.CONTACT_ID;
    const authCode = process.env.AUTH_CODE;

    if (!domainName) {
      console.error('Please specify a domain name to register');
      return;
    }

    if (!contactID) {
      console.error('Please specify a contact ID to register the domain with');
      return;
    }

    if (!authCode) {
      console.error('Please specify an auth code to transfer the domain with');
      return;
    }

    const transferAttributes = { registrant_id: contactID, auth_code: authCode };
    const transfer = await dnsimple.registrar.transferDomain(accountID, domainName, transferAttributes);

    console.log(transfer);
  } catch (err) {
    if (err instanceof AuthenticationError) {
      console.error('Authentication error. Check your token is correct for the sandbox environment.');
    } else {
      console.error(err);
    }
  }
})();
