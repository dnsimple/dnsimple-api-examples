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
    const domainName = process.env.DOMAIN || 'dns.com';

    const check = await dnsimple.registrar.checkDomain(accountId, domainName);
    console.log(check);
  } catch (err) {
    if (err instanceof AuthenticationError) {
      console.error('Authentication error. Check your token is correct for the sandbox environment.');
    } else {
      console.error(err);
    }
  }
})();
