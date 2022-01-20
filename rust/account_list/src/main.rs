use crate::account_list::account_list;
use std::fs;

mod account_list;

fn main() {
    let token = token_from_file();
    account_list(&token);
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
