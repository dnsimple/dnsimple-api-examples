# DNSimple Terraform DNS Change Management Demo

Welcome to DNSimple's Terraform DNS Change Management demo. Managing DNS records has never been so straightforward or collaborative. Leveraging the power of DNSimple's Terraform provider and the GitOps approach, this demo guides you through the process of seamlessly managing DNS records for a zone. By integrating these tools, you'll gain clear insights into DNS changes within your PRs, fostering transparency and democratizing DNS management access across teams.

What you'll gain from this demo:

- DNSimple & Terraform Integration
Discover the seamless integration of DNSimple's Terraform provider, making DNS record management more efficient and developer-friendly.

- GitOps-Driven Feedback
Get instant feedback on your DNS changes directly in your Pull Requests (PRs) by following a GitOps approach. This ensures every member is informed of the changes before they're merged.

- Democratizing DNS Management
Empower team members across different departments and skill sets to propose, review, and approve DNS changes without requiring deep DNS knowledge.

- Version-Controlled DNS Changes
Every change is tracked in your version control system, ensuring a complete audit trail and allowing teams to rollback if necessary.

- Collaborative Approach
Facilitate communication between developers, operations, and other stakeholders, reducing silos and promoting a unified approach to DNS management.

- Enhanced Security
Decentralize DNS management access and maintain a clear audit trail, reducing potential security risks and ensuring accountability.

- Quick Setup
Get up and running quickly with our step-by-step guide, regardless of your familiarity with Terraform or DNSimple.

- Sample Use-Cases
Explore practical scenarios and use-cases that showcase the benefits and capabilities of this integrated approach.

## Prerequisites

- A zone on DNSimple (e.g. `example.com`) - whether it's registered with DNSimple or not. It doesn't need to be managed by DNSimple's name servers, but you won't be able to see the changes live using just DNSimple's UI. Don't have an account? [Sign up free](https://dnsimple.com/sign_up). If you'd like to register and set up a domain entirely through Terraform, check out our [domains demo](../domains).
- API access token with write access to the zone. Create a new token by [following our support article](https://support.dnsimple.com/articles/api-access-token/). Note the token and your account ID, as you will need them later.
- Terraform CLI installed on your machine. Download the latest version from the [Terraform website](https://www.terraform.io/downloads.html). Alternatively, use the devcontainer in this repository to get up and running quickly.

## Getting Started

The following instructions will guide you through setting up Terraform, connecting it with DNSimple, running your first plan and applying the changes.

By default the Terraform state will be stored locally on your machine. If you want to collaborate with other users, you may want to consider to using a shared location like Terraform Cloud to store the state, and move the repository to a hosting service such as GitHub. More instructions are provided below.


### Step 1: Clone the repository

Clone this repository to your local machine:

```bash
git clone https://github.com/dnsimple/terraform-manage-repos.git
cd dnsimple-api-examples/terraform/dns-change-management
```

### Step 2: Initialize Terraform

Initialize Terraform to download the DNSimple provider by running the following command:

```bash
terraform init
```

### Step 3: Create a Terraform variables file

Create a `terraform.tfvars` file from the template included in this repo. This file will contain the variables that will be used by Terraform to authenticate the DNSimple provider.

```bash
cp terraform.tfvars.example terraform.tfvars
```

Open the `terraform.tfvars` file and replace the `dnsimple_token` and `dnsimple_account` values with your DNSimple API token and account ID respectively. If you are using a [sandbox account](https://developer.dnsimple.com/sandbox/), you can change `dnsimple_sandbox` to `true`.

### Step 4: Create a Terraform plan

Before creating a plan, update the domain name in the `main.tf` file to match the zone you want to manage. Do this by updating the `domain` local variable:

```hcl
locals {
  domain = "<your-domain>"
}
```

Create a Terraform plan by running the following command:

```bash
terraform plan
```

This will show you the changes that Terraform will apply to your zone.

### Step 5: Apply the Terraform plan

Apply the Terraform plan by running the following command:

```bash
terraform apply
```

This will apply the changes to your zone. First you will be prompted to confirm the changes. Type `yes` and press enter to continue. You can now check your zone on DNSimple to see the changes.


### Step 6: Remove all changes

Destroy the records created via Terraform by running the following command:

```bash
terraform destroy
```

This will remove the changes from your zone. You can now check your zone on DNSimple to see the changes.


## Sample Use-Cases

### Adding a new record

Let's say you want to add a new `A` record for `local.example.com` pointing to `127.0.0.1` to your zone. You can do this by adding the following to your `main.tf` file:

```hcl
resource "dnsimple_zone_record" "local" {
  domain = "example.com"
  name   = "local"
  type   = "A"
  value  = "127.0.0.1"
  ttl    = 3600
}
```

You can now create a Pull Request with your changes. You will see the **terraform-plan.yml** workflow run and post a comment with the output of `terraform plan`. Review the changes, and approve the Pull Request. Merge the Pull Request, and you will see the **terraform-apply.yml** workflow run and apply the changes to your DNSimple account. You can now check your zone on DNSimple to see the changes.

### Updating an existing record

Let's say you want to update the `A` record for `local.example.com` to point to `198.162.0.1` instead of `127.0.0.1`. Do this by updating the `value` attribute in your `main.tf` file:

```hcl
resource "dnsimple_zone_record" "local" {
  domain = "example.com"
  name   = "local"
  type   = "A"
  value  = "198.162.0.1"
}
```

You can now create a Pull Request with your changes. You will see the **terraform-plan.yml** workflow run and post a comment with the output of `terraform plan`. Review the changes, and approve the Pull Request. Merge the Pull Request, and you will see the **terraform-apply.yml** workflow run and apply the changes to your DNSimple account. You can now check your zone on DNSimple to see the changes.


## Hosting with Terraform Cloud

The code of this example is designed to store the Terraform state locally, on your machine. While this is the fastest way to get started, it's not very convenient if you want to collaborate with other users, or if you don't want to rely on your machine all the time.

Terraform supports [various backend configuration](https://developer.hashicorp.com/terraform/language/settings/backends/configuration), one of the most convenient being the [Terraform Cloud backend](https://developer.hashicorp.com/terraform/language/settings/terraform-cloud).

You can switch to a different backend at any time, and migrate the current state. To use Terraform Cloud first setup your account:

- Sign in for Terraform Cloud
- Create a new Organization (e.g. `MyOrganization`)
- Create a new Workspace (e.g. `terraform-dnsimple-zone`)
- Create a new Team API key

Update the `provider.tf` and add the `cloud` configuration before the `required_providers` statement:

```hcl
terraform {
  cloud {
    organization = "MyOrganization"

    workspaces {
      name = "terraform-dnsimple-zone"
    }
  }

  // here goes the remaining config
  // [...]
}
```

Now you can also conveniently move the configuration variables from the `terraform.tfvars` file directly into your Terraform Workspace configuration, and delete the file.

Login into Terraform Cloud via CLI, and just use Terraform as you used before.

```bash
# login and follow the instructions
terraform login

# run the plan
terraform plan
```


## Automating with GitHub Actions/GitLab Flows

Running Terraform from your computer can be inconvenient if you want to coordinate with other users. One option is to store the repository on GitHub/GitLab, and use GitHub Actions or GitLab Flows to automate the workflow.

You can find the base template for both services in the official HashiCorp documentation:

- https://github.com/hashicorp/tfc-workflows-github
- https://github.com/hashicorp/tfc-workflows-gitlab

The conventional approach is to configure Terraform Plan to run on the creation of a new Pull Request / Merge Request, and Terraform Apply to run when the branch is merged into the main branch.


## What's next?

Extend your DNS management capabilities by exploring the following resources:

- Improve security and compliance by using HashiCorp Sentinel to enforce policy-as-code with the [DNSimple Terraform Sentinel Demo](../sentinel)
- Register and manage domains with Terraform using the [DNSimple Domains Demo](../domains)
- End-to-end example of using Terraform to provision TLS certificates with DNSimple's Let's Encrypt endpoint using the [DNSimple Terraform TLS Demo](../tls-web-application)
- Learn how to dynamically provision DNS records for Consul services with the [DNSimple Consul Demo](../consul)
