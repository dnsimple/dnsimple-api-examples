use std::fs;

pub fn token_from_file() -> String {
    let token = fs::read_to_string("./token.txt")
        .unwrap()
        .parse::<String>()
        .unwrap();
    token
}
