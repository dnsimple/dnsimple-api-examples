use crate::cancel_domain_transfer::cancel_domain_transfer;
use std::{env, fs};

mod cancel_domain_transfer;

fn main() {
    let token = token_from_file();
    let args: Vec<String> = env::args().collect();
    cancel_domain_transfer(
        &*token,
        &args[1],
        args.last().unwrap().parse::<u64>().unwrap(),
    );
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
