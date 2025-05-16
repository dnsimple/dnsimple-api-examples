# DNSimple API Python Examples

The scripts in this directory demonstrate how to use the DNSimple Python API wrapper to connect to the DNSimple API.

## Running

First you will need to ensure you have python 3 installed.

Once you are sure python 3 is installed it's time to install the Python API client

`pip install dnsimple`

You can also install the Python API client by cloning it from github

`git clone git@github.com:dnsimple/dnsimple-python.git`

and installing it locally to your system

`pip install -r <path-to-your-local-clone>/requirements.txt`
`pip install <path-to-your-local-clone>`

Now create a file called `token.txt` and put your token in it:

``` your_token ```

The token is an account token you generated on the DNSimple site from an account screen. Most of the example
scripts will expect this type of token. There is another token, a user token, which is generated on the DNSimple site
in your account management screen. The user token will be accepted, but since it is scoped to a user, which may access
multiple accounts, no account information is populated from the whoami endpoint when a user token is supplied, therefore
either the account id must be known in advance, or an extra step must be taken to get the account id.

**Unless otherwise noted**, all scripts expect an account token.

Now you can run individual scripts either by running the script directly or by prefixing the script name with `python`.

For example `./account_list.py` and `python3 account_list.py` should both work.
