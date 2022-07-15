use dnsimple::dnsimple::new_client;
use dnsimple_rust_sample_code::token_from_file;
use std::env;

fn main() {
    let token = token_from_file();
    let args: Vec<String> = env::args().collect();
    get_domain_transfer(
        &*token,
        &args[1],
        args.last().unwrap().parse::<u64>().unwrap(),
    );
}

pub fn get_domain_transfer(token: &str, domain_name: &str, transfer_id: u64) {
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

    println!(
        "Creating transfer {} for domain {}",
        transfer_id, domain_name
    );

    // get_domain_transfer is the method for retrieving a domain transfer.
    let response =
        client
            .registrar()
            .get_domain_transfer(account_id, domain_name.to_string(), transfer_id);

    match response {
        Ok(r) => {
            let transfer = r.data.unwrap();
            println!("State: {}", transfer.state);
            println!("Status: {}", transfer.status_description.unwrap())
        }
        Err(e) => {
            println!("Transfer request had error: {}", e)
        }
    }
}
