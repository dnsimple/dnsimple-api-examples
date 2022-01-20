use crate::list_zone_records::list_zone_records;
use std::fs;

mod list_zone_records;

fn main() {
    let token = token_from_file();

    list_zone_records(&*token);
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
