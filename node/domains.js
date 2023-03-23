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

    let domainCount = 0;
    for await (const domains of dnsimple.domains.listDomains.iterateAll(accountID, { sort: 'id:asc', per_page: 4 })) {
      console.log(domains);

      // Print only the first 4 domains
      if (domainCount >= 3) {
        break;
      }
      domainCount++;
    }
  } catch (err) {
    if (err instanceof AuthenticationError) {
      console.error('Authentication error. Check your token is correct for the sandbox environment.');
    } else {
      console.error(err);
    }
  }
})();
