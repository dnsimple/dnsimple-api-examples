use std::fs;

pub fn token_from_file() -> String {
    let token: String = fs::read_to_string("./token.txt").unwrap();
    token.trim().to_string()
}
