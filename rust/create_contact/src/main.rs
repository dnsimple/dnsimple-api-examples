use crate::create_contact::create_contact;
use std::{env, fs};

mod create_contact;

fn main() {
    let token = token_from_file();
    let args: Vec<String> = env::args().collect();
    create_contact(&*token, &args[1]);
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
