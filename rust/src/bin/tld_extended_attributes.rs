use dnsimple::dnsimple::new_client;
use dnsimple_rust_sample_code::token_from_file;
use std::env;

fn main() {
    let token = token_from_file();
    let args: Vec<String> = env::args().collect();

    tld_extended_attributes(&*token, &args[1]);
}

pub fn tld_extended_attributes(token: &str, tld: &str) {
    // Construct a client instance
    //
    // If you want to connect to production set the sandbox argument to false
    let client = new_client(true, token.to_string());

    // get_extended_attributes is the function to retrieve the extended attributes for a particular
    // TLD.
    let response = client.tlds().get_tld_extended_attributes(tld.to_string());

    println!(
        "The extended attributes for tld {}: {:?}",
        tld,
        response.unwrap().data.unwrap()
    );
}
