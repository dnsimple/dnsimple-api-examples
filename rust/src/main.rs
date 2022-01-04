use crate::account_list::account_list;
use crate::auth::whoami;
use crate::bad_auth::bad_auth;
use std::fs;

mod account_list;
mod auth;
mod bad_auth;
mod cancel_domain_transfer;

fn main() {
    let token = token_from_file();
    account_list(&token);
    whoami(&token);
    bad_auth();
}

fn token_from_file() -> String {
    let mut token = fs::read_to_string("./token.txt")
        .unwrap()
        .parse::<String>()
        .unwrap();
    let len = token.len();
    token.truncate(len - 1);
    println!("Using {} as your current token", token);
    token
}
