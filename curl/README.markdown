# DNSimple API curl Example

The scripts in this directory demonstrate how to use curl to connect to the DNSimple API.

The scripts here were developed to run with bash.

## Running

Make sure you have curl installed first.

Once you do, run scripts like this:

`TOKEN=token ./script.sh`

Many scripts will require additional variables, such as the account ID of the account you would like to operate on. In these cases additional arguments will be passed via the command-line arguments. For example:

`TOKEN=token ./domains.sh 1234`

Each script should have a comment explaining its usage as well.
