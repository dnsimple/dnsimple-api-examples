# DNSimple Terraform TLS Demo

This demo showcases how to manage and secure a DNSimple delegated domain with an SSL certificate using the DNSimple Terraform Provider. Manage your domain with DNSimple, order a Let's Encrypt SSL certificate, and build a containerized web application using Docker. The resulting container image will use Nginx to serve a static HTML page with TLS enabled using the requested certificate. 

With the DNSimple Terraform provider, you can use regular Terraform syntax and resources to manage and automate every aspect of your domain's lifecycle. This includes tasks like domain registration, DNS record management, and the issuance of SSL certificates. The integration with DNSimple leveraging Let's Encrypt ensures that the SSL certificates automatically renewed, eliminating the manual steps and oversight traditionally required. Leveraging the capabilities of Infrastructure-as-Code, business operators can ensure a consistent, reproducible, and secure domain environment. Furthermore, by integrating DNSimple with Terraform, you can seamlessly integrate domain management into your existing DevOps workflows. This not only saves time but also reduces the potential for human error, ensuring that your web assets are always secure and accessible.

## Requirements

- Docker
- Terraform

## DevContainer

The provided `.devcontainer` configures Debian Bullseye with:

- common-utils
- docker-outside-of-docker
- node
- terraform

## Setup

### 1. Set Terraform Variables

Create `terraform/terraform.tfvars` and set the following variables:

```
dnsimple_account = "{DNSIMPLE_ACCOUNT_ID}"
dnsimple_token = "{DNSIMPLE_API_TOKEN}"
dnsimple_domain = "{DNSIMPLE_REGISTERED_DOMAIN.TLD}"
```

See `terraform.tfvars.example` for examples.

## 2. Run Terraform

1. `cd terraform`
2. `terraform init`
3. `terraform import dnsimple_domain.domain {DNSIMPLE_DOMAIN.TLD}`
4. `terraform plan`
5. `terraform apply`

### Verify

Once `terraform apply` completes, check the resulting docker container is running on the host.

1. `docker ps`

```
CONTAINER ID   IMAGE            COMMAND                  CREATED         STATUS         PORTS                                             NAMES
e429c8e507cb   1b3b7839db87     "/docker-entrypoint.…"   8 seconds ago   Up 7 seconds   127.0.0.1:8080->80/tcp, 127.0.0.1:8443->443/tcp   terraform-tls-demo
3628bf8dcb
```

2. Create a `hosts` entry for your domain pointing to localhost.

Replace `example.com` with your configured `dnsimple_domain`

```
127.0.0.1       example.com
```

3. Navigate to `https://example.com:8443` to verify TLS. 
