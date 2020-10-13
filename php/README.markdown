# DNSimple API PHP Examples

The scripts in this directory demonstrate how to use the DNSimple PHP API wrapper to connect to the DNSimple API.

## Running

First you will need to ensure PHP is installed and then run `php -v`.

Once you install the dependencies (via [composer](https://getcomposer.org/)), create a file called `token.php` and put the following into it:

```php
<?php

$token = "your_token";
```

Where `your_token` is an account token (_we recommend using your sandbox environment token to test_) you generated on the DNSimple site from an account screen. Most of the example
scripts will expect this type of token. There is another token, a user token, which is generated on the DNSimple site
in your account management screen. The user token will be accepted, but since it is scoped to a user, which may access
multiple accounts, no account information is populated from the whoami endpoint when a user token is supplied, therefore
either the account id must be known in advance or an extra step must be taken to get the account id.

**Unless otherwise noted**, all scripts expect an account token.

Now you can run individual scripts either by running the script directly or by prefixing the script name with `php`.

For example:

`./badauth.php`

And

`php badauth.php`

Should both work.
