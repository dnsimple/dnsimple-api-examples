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
    const transferId = process.env.TRANSFER_ID;

    if (!domainName) {
      console.error('Please specify a domain name to register');
      return;
    }

    if (!transferId) {
      console.error('Please specify a transfer ID to cancel the transfer with');
      return;
    }

    const transfer = await dnsimple.registrar.cancelDomainTransfer(accountId, domainName, transferId);
    console.log(transfer);
  } catch (err) {
    if (err instanceof AuthenticationError) {
      console.error('Authentication error. Check your token is correct for the sandbox environment.');
    } else {
      console.error(err);
    }
  }
})();
