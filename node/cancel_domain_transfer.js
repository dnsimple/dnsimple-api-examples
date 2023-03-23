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
    const transferID = process.env.TRANSFER_ID;

    if (!domainName) {
      console.error('Please specify a domain name to register');
      return;
    }

    if (!transferID) {
      console.error('Please specify a transfer ID to cancel the transfer with');
      return;
    }

    const transfer = await dnsimple.registrar.cancelDomainTransfer(accountID, domainName, transferID);

    console.log(transfer);
  } catch (err) {
    if (err instanceof AuthenticationError) {
      console.error('Authentication error. Check your token is correct for the sandbox environment.');
    } else {
      console.error(err);
    }
  }
})();
