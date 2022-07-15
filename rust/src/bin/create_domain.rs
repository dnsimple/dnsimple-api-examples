use dnsimple::dnsimple::new_client;
use dnsimple_rust_sample_code::token_from_file;
use std::env;

fn main() {
    let token = token_from_file();
    let args: Vec<String> = env::args().collect();
    create_domain(&*token, &args[1]);
}

pub fn create_domain(token: &str, domain_name: &str) {
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

    println!("Creating domain {}", domain_name);

    let response = client
        .domains()
        .create_domain(account_id, domain_name.to_string());

    if let Err(e) = response {
        println!("Error creating domain: {}", e);
        return;
    }

    let new_domain = response.unwrap().data;

    match new_domain {
        None => {
            println!("No domain returned!")
        }
        Some(d) => {
            println!("Name: {}\nState: {}", d.name, d.state)
        }
    }
}
