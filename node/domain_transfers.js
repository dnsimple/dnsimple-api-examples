const { DNSimple, AuthenticationError } = require('dnsimple');

(async () => {
  const dnsimple = new DNSimple({
    baseUrl: 'https://api.sandbox.dnsimple.com',
    accessToken: process.env.TOKEN,
    userAgent: 'dnsimple-examples',
  });

  // Provide the domain name (e.g. example.com) as the first CLI argument...
  const name = process.argv[2];
  // ...and the transfer ID (e.g. 42) as the second CLI argument.
  const transferId = process.argv[3];

  try {
    const identity = await dnsimple.identity.whoami();
    const accountId = identity.data.account.id;
    const transfer = await dnsimple.registrar.getDomainTransfer(accountId, name, transferId);
    console.log(transfer);
  } catch (err) {
    if (err instanceof AuthenticationError) {
      console.error('Authentication error. Check your token is correct for the sandbox environment.');
    } else {
      console.error(err);
    }
  }
})();
