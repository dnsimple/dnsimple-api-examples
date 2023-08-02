# DNSimple API Node Examples

The scripts in this directory demonstrate how to use the DNSimple Node API wrapper to connect to the DNSimple API.

You will need to have the DNSimple node client installed. You can install it using `npm install dnsimple`.

# Running

```
node badauth.js
```

or

```
TOKEN=token node auth.js
```

Some scripts require command line arguments. For example, to check availability of a domain:

```
TOKEN=token DOMAIN=example.com node check.js
```
