use crate::create_domain::create_domain;
use std::{env, fs};

mod create_domain;

fn main() {
    let token = token_from_file();
    let args: Vec<String> = env::args().collect();
    create_domain(&*token, &args[1]);
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
