### Introduction:

In this demo, we will use CoreDNS compiled with the [DNSimple plugin](https://github.com/dnsimple/coredns-dnsimple/) to deploy an on-premise CoreDNS instance with DNS record management from within the DNSimple web application.

DNSimple's CoreDNS plugin enables businesses and individual developers alike to leverage the extensibility of CoreDNS, while managing DNS records effortlessly through DNSimple's intuitive web application. Not only will this integration facilitate streamlined DNS record management but it will also ensure that your on-premise DNS resolution is tightly aligned with any changes or updates made within DNSimple’s platform. Whether managing a singular domain or juggling numerous domains with many DNS records, offer increased reliability, ease of management, and enterprise-level stability with DNSimple and CoreDNS.

### Prerequisites:

- A machine where you can install and run CoreDNS (local workstation, virtual machine or physical server)
- A domain managed with DNSimple
- An API token from DNSimple, which will allow CoreDNS to access DNSimple’s services
- Basic knowledge of DNS and terminal/command line usage
- Go installed (if you're going to build CoreDNS from source)

### Step 1: Enable the DNSimple CoreDNS Integration

1. From the DNSimple application, navigate to the 'Domain->Integrations' page.

2. Select 'Configure' next to the CoreDNS integration in the domain settings.

3. Leave the Cluster Identifier value as `default`. 

4. **Note** down your DNSimple `account_id` in the example Corefile.

5. Click 'Create Integration' and verify the CoreDNS integration is active.

### Step 2: Compile/Install CoreDNS

<details>
<summary>Option A: Downloading the Precompiled Binary</summary>
<br>
1. Go to the [DNSimple CoreDNS releases page](https://github.com/dnsimple/coredns-dnsimple/releases)
2. Download the latest release for your OS
3. Extract and move the binary to a location in your PATH
</details>

<details>
<summary>Option B: Build from Source</summary>
<br>
1. Clone the CoreDNS repository
Clone the CoreDNS source code from its official GitHub repository.

```shell
git clone https://github.com/coredns/coredns.git
```

2. Navigate to the CoreDNS directory
Switch to the coredns directory which has been cloned to your local system.

```shell
cd coredns
```

3: Add the DNSimple Plugin to `plugin.cfg`
Modify the plugin.cfg file to include the DNSimple plugin by adding the import statement immeditely after route53.

```txt
route53:route53
dnsimple:github.com/dnsimple/coredns-dnsimple
...
```

4. Load the CoreDNS DNSimple Plugin
Utilize go get to download the DNSimple plugin, making it available for the upcoming build process.

```shell
go get github.com/dnsimple/coredns-dnsimple
```

5. Build CoreDNS with the External Plugin
Trigger the build process, generating a new CoreDNS binary that includes the DNSimple plugin.

```shell
go generate && go build
```

6. Verify and move the binary to a location in your PATH
</details>

### Step 3: Export your DNSimple Credentials

```shell
export DNSIMPLE_ACCOUNT_ID=1234
export DNSIMPLE_TOKEN=dnsimple-api-token
```

Replace the `DNSIMPLE_ACCOUNT_ID` and `DNSIMPLE_TOKEN` values with your actual DNSimple credentials.

### Step 4: Create a Corefile and Run CoreDNS

1. Create a `Corefile`.

```txt
.:53 {
    dnsimple DNSIMPLE_MANAGED_DOMAIN.TLD {
        identifier "default"
        refresh    60s
    }
    forward . 1.1.1.1
    cache
    log
    errors
}
```

Replace `DNSIMPLE_MANAGED_DOMAIN.TLD` with your actual domain managed at DNSimple. This configuration will use DNSimple for domain information and forward other queries to Cloudflare’s Public DNS server (1.1.1.1).

2. With the `Corefile` created, start CoreDNS pointing to your `Corefile`.

```shell
coredns -conf ./Corefile
```

### Step 5: Test DNS Resolution

From another machine, or the same machine, query the DNS server to ensure that it is resolving domains correctly.

```shell
dig @{DNS_SERVER_ADDRESS} {DNSIMPLE_MANAGED_DOMAIN.TLD}
```

### Conclusion:

You should now have a basic on-premise DNS server setup using CoreDNS and DNSimple. Make sure to adjust firewall rules, routing, and security settings according to your network setup and security policy to ensure the DNS server operates reliably and securely.
