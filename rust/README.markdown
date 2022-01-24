#DNSimple API Rust Examples

The scripts in this directory demonstrate how to use the DNSimple Rust API wrapper to connect to the DNSimple API.

## Running

Create a file called `token.txt` and put your [Sandbox DNSimple](https://developer.dnsimple.com/sandbox/) account token in it.

**Unless otherwise noted**, all scripts expect a working account token.

Now you can run individual examples using cargo run.

For example:

```shell
cargo run --bin bad_auth
cargo run --bin check example.com
```
