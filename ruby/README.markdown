# DNSimple API Ruby Examples

The scripts in this directory demonstrate how to use the DNSimple Ruby API wrapper to connect to the DNSimple API.

These scripts are used as examples in the 5-day DNSimple API mini-course.

## Running

First you will need to ensure bundler is installed and then run `bundle`.

Once the dependencies are installed, create a file called `token.rb` and put the following into it:

```ruby
TOKEN = "your_token"
```

Where `your_token` is an account token you generated on the DNSimple site from an account screen. Most of the example
scripts will expect this type of token. There is another token, a user token, which is generated on the DNSimple site
in your account management screen. The user token will be accepted, but since it is scoped to a user, which may access
multiple accounts, no account information is populated from the whoami endpoint when a user token is supplied, therefore
either the account id must be known in advance or an extra step must be taken to get the account id.

**Unless otherwise noted**, all scripts expect an account token.

Now you can run individual scripts either by running the script directly or by prefixing the script name with `ruby `.

For example:

`./badauth.rb`

And

`ruby badauth.rb`

Should both work.

## Environments

All scripts are set up to run against the DNSimple sandbox API by default. If you wish to run a script against the
production API, add a command argument `prod` in the appropriate position when calling a script.
