# DNSimple TLS & Terraform

An example library using Terraform to configure a DNSimple registered domain with TLS using Let's Encrypt.

The demo web application is built using vite + react. The web application build is copied into the docker image defined in `terraform/main.tf` along with the resulting SSL/TLS certificate data and required nginx configurations.

## Requirements

- Docker
- NodeJS
- Terraform

## DevContainer

The provided `.devcontainer` configures Debian Bullseye with:

- common-utils
- docker-outside-of-docker
- node
- terraform

## Setup

### Build Web Application

Requires NodeJS + preferred package manager (examples using yarn)

1. `cd react-app`
2. `yarn && yarn build`

### Terraform Variables

Create `terraform/terraform.tfvars` and set the following variables:

```
dnsimple_account = "{ACCOUNT_ID}"
dnsimple_token = "{API_TOKEN}"
dnsimple_domain = "{DNSIMPLE_REGISTERED_DOMAIN.TLD}"
```

See `terraform.tfvars.example` for examples.

## Run Terraform

1. `cd terraform`
2. `terraform init`
3. `terraform import dnsimple_registered_domain.domain {DNSIMPLE_REGISTERED_DOMAIN.TLD}` (Optional)
4. `terraform plan`
5. `terraform apply`

### Verify

1. `docker ps`

```
CONTAINER ID   IMAGE            COMMAND                  CREATED         STATUS         PORTS                                             NAMES
e429c8e507cb   1b3b7839db87     "/docker-entrypoint.…"   8 seconds ago   Up 7 seconds   127.0.0.1:8080->80/tcp, 127.0.0.1:8443->443/tcp   terraform-tls-demo
3628bf8dcb
```
