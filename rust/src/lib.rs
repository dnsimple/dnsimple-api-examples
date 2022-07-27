use std::fs;

pub fn token_from_file() -> String {
    match fs::read_to_string("./token.txt") {
        Ok(i) => i.trim().to_string(),
        Err(e) => panic!("Could not read token from ./token.txt: {e}"),
    }
}
