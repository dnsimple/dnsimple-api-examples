use dnsimple::dnsimple::new_client;
use dnsimple_rust_sample_code::token_from_file;

fn main() {
    let token = token_from_file();
    whoami(&token);
}

pub fn whoami(token: &str) {
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

    // Note:
    //      The `user` property will be `None` if an account token was supplied
    //      The `account` property will be `None` if a user token was supplied

    let account = whoami.account.unwrap();
    println!(
        "Account ID: {}\nAccount Email: {}\nPlan: {}",
        account.id, account.email, account.plan_identifier
    );
}
