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

    if (!domainName) {
      console.error('Please specify a domain name to create');
      return;
    }

    const domain = await dnsimple.domains.createDomain(accountId, { name: domainName });
    console.log(domain);
  } catch (err) {
    if (err instanceof AuthenticationError) {
      console.error('Authentication error. Check your token is correct for the sandbox environment.');
    } else {
      console.error(err);
    }
  }
})();
