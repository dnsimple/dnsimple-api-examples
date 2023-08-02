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

    const contactDetails = {
      label: 'Alice Appleseed (US)',
      email: 'alice.appleseed@example.com',
      first_name: 'Alice',
      last_name: 'Appleseed',
      address1: '111 SW 1st Street',
      city: 'Miami',
      state_province: 'FL',
      postal_code: '11111',
      country: 'US',
      phone: '+1 321 555 4444',
    };

    const contact = await dnsimple.contacts.createContact(accountId, contactDetails);
    console.log(contact);
  } catch (err) {
    if (err instanceof AuthenticationError) {
      console.error('Authentication error. Check your token is correct for the sandbox environment.');
    } else {
      console.error(err);
    }
  }
})();
