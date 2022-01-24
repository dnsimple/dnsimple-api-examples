#DNSimple API Rust Examples

The scripts in this directory demonstrate how to use the DNSimple Rust API wrapper to connect to the DNSimple API.

## Running

Create a file called `token.txt` and put the following into it:

```txt
your_token
```

Where `your_token` is an account token you generated on the DNSimple site from an account screen. Most of the example
scripts will expect this type of token. There is another token, a user token, which is generated on the DNSimple site
in your account management screen. The user token will be accepted, but since it is scoped to a user, which may access
multiple accounts, no account information is populated from the whoami endpoint when a user token is supplied, therefore
either the account id must be known in advance or an extra step must be taken to get the account id.

**Unless otherwise noted**, all scripts expect an account token.

Now you can run individual scripts.

For example:

`cargo run bad_auth`
