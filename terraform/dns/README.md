# DNSimple Terraform DNS Demo

With the DNSimple Terraform Provider, you can manage your DNS infrastructure, including zones and records, directly within Terraform. This allows you to leverage the simplicity and power of Terraform's Infrastructure-as-Code design for your DNSimple resources, and coordinate them right alongside your other Terraform resources that form your infrastructure.

To provide an example of the power, simplicity, and functionality of managing DNS using the DNSimple Terraform Provider, we've provided this demo that you can review, run, and play around with. We'll implement a basic email inbox service that has a simple but relatable design and structure of a full stack application with all the typical infrastructure:

- An S3 bucket, acting as the data store, containing incoming emails collected via SES.
- An [API service](./api.py), running on EC2 instances, distributed across two regions, that will serve the emails.
- A simple [static web application](./app.html) that will be stored and served from an S3 bucket, which will present a UI for the data returned by the API.

We'll showcase how, by using the DNSimple Terraform Provider, setting up the required DNS plumbing for this and almost all other services like it can enable smoother and more powerful planning, design, and operations of infrastructure:

- DNS records are declared right alongside the components and resources they serve, so there's no loss of context or need for disjointed external tools or manual processes.
- The Terraform resources can be committed to your VCS for centralising the source of truth, keeping declarations and state in sync, automated deployments, regression testing, policy enforcement, and inspecting the history of changes.
- Leverage the full power of DNSimple's functionality and tools, like ALIAS and regional records, to empower your architecture.
- Take advantage of all of Terraform's benefits with DNS records that are just like any other resource: drift detection, one-command deployment and synchronisation, clean and structured deletion, automatic dependency resolution, track and centralise state, and more.

Feel free to use this proof-of-concept as the starting point for your next project, or as inspiration to swap parts out to build something completely different.

## Prerequisites

To run this demo, you will need:

- An authoritative zone on DNSimple, where the DNS resolution is not delegated or disabled. If you purchased or transferred your domain to DNSimple, or you have pointed your domain's nameservers to DNSimple at your registrar, you should be good to go.
  - If you'd like to registrar and set up a domain also entirely through Terraform, check out our [domains demo](../domains).
- An API token for your DNSimple account must be generated and stored in your environment variables. See [here](https://support.dnsimple.com/articles/api-access-token/) for more details.
- An AWS account. You must have AWS credentials on your machine ready to go. See [this guide](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) for more details.
- Terraform must be installed. You can download it [here](https://developer.hashicorp.com/terraform/downloads).

> [!WARNING]
> DNS records will be overwritten on the zone, which may erase any current records and break services running on your domain.

> [!NOTE]
> This will create resources on your AWS account, which may incur charges. After running this demo, if you don't need it anymore, make sure to delete the resources.

## Running

This demo has been designed such that you only need to follow along the code in [main.tf](./main.tf). Each block has helpful, descriptive comments that are designed to be read like a guide sequentially, and build on top of previous code and comments.

To get started, set up the Terraform project. Only one variable is required to run the demo, which is the domain that you wish to test with. Replace `mydomain.com` with your domain name.

```bash
terraform init
export TF_VAR_domain=mydomain.com
```

Now, you can run the entire demo all at once, by running:

```bash
terraform apply
```

You can also run the demo incrementally, at your pace, by commenting out all code in [main.tf](./main.tf) after the point where you'd like to stop, and then running the above `terraform apply` command. Once you're happy to proceed, uncomment out some more code, and then repeat.

## Cleaning up

You can destroy all resources created by this demo by running:

```bash
terraform destroy
```

You may need to empty your emails S3 bucket first. You can follow this [guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/empty-bucket.html) for more details.

## Notes

As this is a demo, for simplicity reasons, there is no HTTPS set up for the API or the app. Use this demo for fun, not for private or sensitive information.

An interesting exercise is to add HTTPS. You may find our [Terraform TLS Web Application demo](../tls-web-application) helpful in this regard.
