<a href="https://dnsimple.com/">
  <img src="https://developer.dnsimple.com/assets/images/dnsimple-logo-dev.svg" alt="DNSimple" width="250" />
</a>

# Issue Certificates Sample App

Learn how to use [DNSimple](https://dnsimple.com/) to issue certificates for yours or your customers domains.

## Local Development

This project is built on top of the [Sinatra](http://www.sinatrarb.com/) web framework.

1. Clone this repository
   ```bash
   git clone git@github.com:dnsimple/dnsimple-api-examples.git
   cd dnsimple-api-examples/ruby/use_cases/issue_certificates
   ```

2. Install app dependencies
   ```bash
   bundle install
   ```

3. Install operational dependencies
   * [`overmind`](https://github.com/DarthSim/overmind) is recommended but you can also use `foreman`
   * [ngrok](https://ngrok.com/) tunnel proxy to expose the application to the internet

4. Add application configuration
   ```bash
   cp .config.json.example .config.json
   ```
   Enter the information as per the template.

5. Start your development server
   ```bash
   overmind s
   ```
   This will execute the commands as per the [Procfile](Procfile), launching the app on port `4567`.
   To get the ngrok URL you can visit [http://localhost:4040/status](http://localhost:4040/status), make sure to note down the HTTPS URL. On restarting ngrok you will be allocated a new URL.


## Additional details
* No warranty expressed or implied. Software is as is
* [MIT License](https://opensource.org/licenses/mit-license.html)
