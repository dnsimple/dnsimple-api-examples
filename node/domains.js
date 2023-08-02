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

    let domainCount = 0;
    for await (const domains of dnsimple.domains.listDomains.iterateAll(accountId, { sort: 'id:asc', per_page: 4 })) {
      console.log(domains);

      // Print only the first 4 domains.
      if (++domainCount == 4) {
        break;
      }
    }
  } catch (err) {
    if (err instanceof AuthenticationError) {
      console.error('Authentication error. Check your token is correct for the sandbox environment.');
    } else {
      console.error(err);
    }
  }
})();
