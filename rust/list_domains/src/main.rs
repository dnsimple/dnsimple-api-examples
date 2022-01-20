use crate::list_domains::list_domains;
use std::fs;

mod list_domains;

fn main() {
    let token = token_from_file();
    list_domains(&*token);
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
