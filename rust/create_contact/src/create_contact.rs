use dnsimple::dnsimple::contacts::ContactPayload;
use dnsimple::dnsimple::new_client;

pub fn create_contact(token: &str, data: &str) {
    // Construct a client instance
    //
    // If you want to connect to production set the sandbox argument to false
    let client = new_client(true, token.to_string());

    // All calls to client pass through a service. In this case, `client.identity()` is the identity
    // service.
    //
    // `client.identity().whoami` is the method for retrieving the account details for your
    // current credentials via the DNSimple API.
    let whoami = client.identity().whoami().unwrap().data.unwrap();

    // The response object returned by any API method includes a `data` attribute. Underneath
    // that attribute is an attribute for each data object returned. In this case, `account` provides
    // access to the resulting account object.
    //
    // Here the account ID is extracted for use in the call to cancel domain transfer.
    let account_id = whoami.account.unwrap().id;

    let contact: ContactPayload = serde_json::from_str(data).unwrap();

    let response = client.contacts().create_contact(account_id, contact);

    println!("{:?}", response.unwrap().data.unwrap());
}
