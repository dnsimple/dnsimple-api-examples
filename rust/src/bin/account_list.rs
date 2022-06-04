use dnsimple::dnsimple::new_client;
use dnsimple_rust_sample_code::token_from_file;

fn main() {
    let token = token_from_file();
    account_list(&token);
}

pub fn account_list(token: &str) {
    // Construct a client instance
    //
    // If you want to connect to production set the sandbox argument to false
    let client = new_client(true, token.to_string());

    // All calls to client pass through a service. In this case, `client.accounts()` is the accounts
    // service.
    //
    // `client.accounts().list_accounts` is the method for retrieving the list of accounts for your
    // current credentials via the DNSimple API.
    let response = client.accounts().list_accounts().unwrap().data.unwrap();
    let account = response.first().unwrap();

    println!(
        "Account ID: {}\nAccount Email: {}\nPlan: {}",
        account.id, account.email, account.plan_identifier
    );
}
