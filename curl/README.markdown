# DNSimple API curl Example

The scripts in this directory demonstrate how to use curl to connect to the DNSimple API.

## Running

Make sure you have curl installed first.

Once you do, run scripts like this:

`TOKEN=token ./script.sh`

Many scripts will require additional variables, such as the account ID of the account you would like to operate on. In these cases take a look at the script and anything in ${} will need to be sent as an environment variable. For example:

`ACCOUNT=1 TOKEN=token ./domains.sh`

Each script should have a comment explaining its usage as well.
