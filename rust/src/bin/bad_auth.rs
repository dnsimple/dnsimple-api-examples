use dnsimple::dnsimple::new_client;

fn main() {
    bad_auth();
}

pub fn bad_auth() {
    // Construct a client instance
    //
    // If you want to connect to production set the sandbox argument to false
    //
    // Note that in this case a bogus access token is being sent to show what happens when
    // authentication fails.
    let client = new_client(true, "fake".into());

    // All calls to client pass through a service. In this case, `client.identity()` is the identity
    // service.
    //
    // `client.identity().whoami` is the method for retrieving the account details for your
    // current credentials via the DNSimple API.
    let response = client.identity().whoami();

    println!("The server replied with: {:?}", response)
}
