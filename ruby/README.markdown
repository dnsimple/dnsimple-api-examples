# DNSimple API Ruby Example

The scripts in this directory demonstrate how to use the DNSimple Ruby API wrapper to connect to the DNSimple API.

These scripts are used as examples in the 5-day DNSimple API mini-course.

## Running

First you will need to ensure bundler is installed and then run `bundle`.

Once the dependencies are installed, create a file called `token.rb` and put the following into it:

```ruby
TOKEN = "your_token"
```

Where `your_token` is a user token you generated on the DNSimple site in your account management screen.

Now you can run individual scripts either by running the script directly or by prefixing the script name with `ruby `.

For example:

`./badauth.rb`

And

`ruby badauth.rb`

Should both work.
