use dnsimple::dnsimple::new_client;
use dnsimple_rust_sample_code::token_from_file;

fn main() {
    let token = token_from_file();

    list_zone_records(&*token);
}

pub fn list_zone_records(token: &str) {
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

    // list_zones is the function to list the records in a DNSimple zone.
    let response = client.zones().list_zones(account_id, None);

    println!("{:?}", response.unwrap().data.unwrap());
}
