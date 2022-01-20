use crate::transfer_domain::transfer_domain;
use std::{env, fs};

mod transfer_domain;

fn main() {
    let token = token_from_file();
    let args: Vec<String> = env::args().collect();

    transfer_domain(&*token, &args[1], &args[2]);
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
