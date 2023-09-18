# DNSimple Terraform Domains Demo

This is a demo of using the DNSimple Terraform Provider to manage your DNSimple domains with the simplicity and automation of Terraform and Infrastructure-as-Code. This demo showcases how straightforward and easy it is to register, manage, and synchronise your entire domain collection, whether one or one thousand. Many of you will have lots of domains, for various purposes: regional domains, development and infrastructure domains, internal company domains, typosquatting domains, associated brands or marketing domains, and more. With the Terraform provider, you can use regular Terraform syntax and resources, and leverage all of Terraform's features and advantages, to ensure your domains are protected and high quality without any error-prone, tedious, or confusing manual processes or external tools. You can learn more on our [blog](https://blog.dnsimple.com/2023/06/terraform-domain-registrations/).

What this demo does:

- Creates a contact to be used for all of your domains.
- Defines a list of domains in [domains.json](./domains.json), which will be provided to Terraform.
- Registers and synchronises all these domains using the `dnsimple_registered_domain` Terraform resource.

With this simple combo, you can:

- Register more domains simply by adding a line to `domains.json`.
- Detect drift at any domain, which could be caused by unintentional or suspicious activity.
- Keep your entire set of domain properties in sync and managed.
- Update contacts for all domains with just one command.

You can build on top of this simple core usage by leveraging many other DNSimple features, like DNS, SSL certificates, email forwarding, and more, using the same Terraform script and approach, with the same simplicity and automation at scale. There are many demos for these within this repo; check them out [here](../).

## Prerequisites

To run this demo, you will need an API token for your DNSimple account must be generated and stored in your environment variables. See [here](https://support.dnsimple.com/articles/api-access-token/) for more details.

Terraform must be installed. You can download it [here](https://developer.hashicorp.com/terraform/downloads).

> [!WARNING]
> This demo will attempt to register domains, which will incur charges on your account. We recommend running this demo in the sandbox first. Learn more about the sandbox environment [here](https://developer.dnsimple.com/sandbox/).

## Running

Modify the `domains.json` to reflect which domains you'd like to register. Once that's done, set up the Terraform project:

```bash
terraform init
```

Now, you're ready to apply the Terraform resources. This will begin the process of registering the domains to your DNSimple account. To proceed:

```bash
terraform apply
```

## Notes

Your domains aren't deleted when you destroy the Terraform resources, for safety reasons. This means that those domains will remain registered to you even after you complete this demo and clean up the Terraform resources.

## See also


- [DNSimple Terraform Provider](https://support.dnsimple.com/articles/terraform-provider/)
- [Register and Manage Domains with Terraform](https://blog.dnsimple.com/2023/06/terraform-domain-registrations/)
- [dnsimple_registered_domain](https://registry.terraform.io/providers/dnsimple/dnsimple/latest/docs/resources/registered_domain)
