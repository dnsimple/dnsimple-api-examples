# DNSimple Terraform DNS Change Management Demo

Welcome to the "DNSimple Terraform DNS Change Management" demo! Managing DNS records has never been so straightforward and collaborative. Leveraging the power of DNSimple's Terraform provider and the GitOps approach, this demo guides you through the process of managing DNS records for a zone seamlessly. By integrating these tools, you can now gain clear insights into DNS changes right within your PRs, fostering transparency and democratizing DNS management access across teams.

What you can to gain from this demo:

- DNSimple & Terraform Integration
Discover the seamless integration of DNSimple's Terraform provider, making DNS record management more efficient and developer-friendly.

- GitOps-Driven Feedback
By following a GitOps approach, get instant feedback on your DNS changes directly in your Pull Requests (PRs). This ensures that every member is informed of the changes before they're merged.

- Democratizing DNS Management
Empower team members across different departments and skill sets to propose, review, and approve DNS changes without requiring deep DNS knowledge.

- Version-Controlled DNS Changes
Every change is tracked in your version control system, ensuring a complete audit trail and allowing teams to rollback if necessary.

- Collaborative Approach
Facilitate communication between developers, operations, and other stakeholders, reducing silos and promoting a unified approach to DNS management.

- Enhanced Security
By decentralizing DNS management access and maintaining a clear audit trail, reduce potential security risks and ensure accountability.

- Quick Setup
Get up and running quickly with our step-by-step guide, regardless of your familiarity with Terraform or DNSimple.

- Sample Use-Cases
Explore practical scenarios and use-cases that showcase the benefits and capabilities of this integrated approach.

## Prerequisites

- A zone on DNSimple (e.g. `example.com`) whether it's registered with DNSimple or not. It also does not need to be managed by DNSimple's name servers, but you will not be able to see the changes live only in the DNSimple UI. Don't have an account? [Sign up for free](https://dnsimple.com/sign_up) today!
  - If you'd like to registrar and set up a domain also entirely through Terraform, check out our [domains demo](../domains).
- API access token with write access to the zone. You can create a new token in the [following our support article](https://support.dnsimple.com/articles/api-access-token/). Please take note of the token and your account ID as you will need them later.
- Terraform CLI installed on your machine. You can download the latest version from the [Terraform website](https://www.terraform.io/downloads.html). Alternatively, you can use the devcontainer in this repository to get up and running quickly.
- GitHub account as this demo uses GitHub Actions to automate the DNS change management process.

## Getting Started

There are two ways to get started with this demo:

- [Running locally](#running-locally)
- [Running on GitHub Actions](#running-on-github-actions)

### Running locally

#### Step 1: Clone the repository

Clone this repository to your local machine:

```bash
git clone git@github.com:dnsimple/dnsimple-api-examples.git
cd dnsimple-api-examples/terraform/dns-change-management
```

#### Step 2: Initialize Terraform

Initialize Terraform to download the DNSimple provider by running the following command:

```bash
terraform init
```

#### Step 3: Create a Terraform variables file

Create a `terraform.tfvars` file from the template included in this repo. This file will contain the variables that will be used by Terraform to authenticate the DNSimple provider.

```bash
cp terraform.tfvars.example terraform.tfvars
```

Open the `terraform.tfvars` file and replace the `dnsimple_token` and `dnsimple_account` values with your DNSimple API token and account ID respectively. If you are using a [sandbox account](https://developer.dnsimple.com/sandbox/), you can change `dnsimple_sandbox` to `true`.

### Step 4: Create a Terraform plan

Before creating a plan, you should update the domain name in the `main.tf` file to match the zone you want to manage. You can do this by updating the `domain` local variable:

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


### Running on GitHub Actions

#### Step 1: Create a new repository

Create a new repository on GitHub for example you can name it `dns-change-management-demo`. You can also fork this repository if you'd like to use it as a starting point.

#### Step 2: Prepare the repository

**Terraform**
- Create a new file named `main.tf` and copy the following content found in the [main.tf](main.tf) file in this repository.
- Create a new file named `variables.tf` and copy the following content found in the [variables.tf](variables.tf) file in this repository.
- Create a new file names `provider.tf` and copy the following content found in the [provider.tf](provider.tf) file in this repository.
- Create a new file named `.gitignore` and copy the following content found in the [.gitignore](.gitignore) file in this repository.

NOTE: As Terraform will run on GitHub Actions, you can will likely want to use a backend like Terraform Cloud or AWS to store your state remotely and securely. You can find examples of how to configure these backends in Step 3 below.

**GitHub Actions**
- Create the following directory structure `.github/workflows/`
```bash
mkdir -p .github/workflows
touch .github/workflows/terraform-plan.yml
touch .github/workflows/terraform-apply.yml
```

Next we will create two new workflows that will be triggered when a Pull Request is opened and pushed to, and when a commit is pushed to the `main` branch, which can be the result of a merge or a direct push. But before we do that, we will need to update the domain name in the `main.tf` file to match the zone you want to manage. You can do this by updating the `domain` local variable:

```hcl
locals {
  domain = "<your-domain>"
}
```

**Speculative Plan**

When you are working on proposing a change through a Pull Request, you can use the **terraform-plan.yml** workflow to get a preview of the changes that will be applied to your account. This workflow will run `terraform plan` and post the output as a comment on the Pull Request.

<details>
  <summary>Click to expand the content of the <b>terraform-plan.yml</b> workflow</summary>

```yaml
name: Terraform Plan
on:
  pull_request:
    branches:
      - main
  workflow_dispatch:

env:
  TF_VAR_dnsimple_token: ${{ secrets.DNSIMPLE_TOKEN }}
  TF_VAR_dnsimple_account: ${{ secrets.DNSIMPLE_ACCOUNT }}
  TF_VAR_dnsimple_sandbox: false

jobs:
  terraform:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2

      - name: Terraform Format
        id: fmt
        run: terraform fmt -check
        continue-on-error: true

      - name: Terraform Init
        id: init
        run: terraform init

      - name: Terraform Validate
        id: validate
        run: terraform validate -no-color

      - name: Terraform Plan
        id: plan
        run: terraform plan -no-color
        continue-on-error: true

      - name: Comment on pull request
        if: ${{ steps.fmt.outcome != 'success' }}
        uses: actions/github-script@v6
        env:
          PLAN: "terraform\n${{ steps.plan.outputs.stdout }}"
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          retries: 3
          script: |
            const output = `#### Terraform Format and Style 🖌\`${{ steps.fmt.outcome }}\`
            #### Terraform Initialization ⚙️\`${{ steps.init.outcome }}\`
            #### Terraform Validation 🤖\`${{ steps.validate.outcome }}\`
            #### Terraform Plan 📖\`${{ steps.plan.outcome }}\`

            <details><summary>Show Plan</summary>

            \`\`\`\n
            ${process.env.PLAN}
            \`\`\`

            </details>

            *Pusher: @${{ github.actor }}, Action: \`${{ github.event_name }}\`*`;

            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: output
            })
```

</details>


**Apply Changes**

When you are ready to apply the changes, you can use the **terraform-apply.yml** workflow to apply the changes to your account. This workflow will run `terraform apply` and post the output as a comment on the Pull Request.
This will usually be the result of a merge after the Pull Request has and it's changes and speculative plan have been reviewed and approved by the team.

<details>
  <summary>Click to expand the content of the <b>terraform-apply.yml</b> workflow</summary>

```yaml
name: Terraform Apply
on:
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: ubuntu-latest
    env:
      TF_VAR_dnsimple_token: ${{ secrets.DNSIMPLE_TOKEN }}
      TF_VAR_dnsimple_account: ${{ secrets.DNSIMPLE_ACCOUNT }}
      TF_VAR_dnsimple_sandbox: false
    steps:
      - uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan -no-color

      - name: Terraform Apply
        if: github.ref == 'refs/heads/main' && github.event_name == 'push'
        run: terraform apply -auto-approve -input=false
```

</details>

NOTE: Please edit the `TF_VAR_dnsimple_sandbox` variable in the workflow if you are using a [sandbox account](https://developer.dnsimple.com/sandbox/).

#### Step 3: Create GitHub Secrets

Our workflows will need access to your DNSimple API token and account ID. To do this, we will create two new secrets in your repository.
You can do this by going to your repository's settings and clicking on the "Secrets" tab. Click on "New repository secret" and create the following secrets:

- `DNSIMPLE_TOKEN` - Your DNSimple API token
- `DNSIMPLE_ACCOUNT` - Your DNSimple account ID

If you have chosen to use a backend like Terraform Cloud or AWS, you will need to add the appropriate secrets and update the workflows accordingly.

<details>
  <summary>Learn more about setting up Terraform Cloud</summary>

If you are using Terraform Cloud, you will need to add the following environment variables to your workflows:

```yaml
  TF_CLOUD_ORGANIZATION: "<your-organization>"
  TF_WORKSPACE: "<your-workspace>"
  TF_API_TOKEN: "${{ secrets.TF_API_TOKEN }}"
```

The only secret you will need to create is `TF_API_TOKEN` which is your Terraform Cloud API token. You can create a new token by going to your [Terraform Cloud user settings](https://app.terraform.io/app/settings/tokens) and clicking on "Create an API token".

</details>

<details>
  <summary>Learn more about setting up AWS</summary>

If you are using AWS, you will need to add the following environment variables to your workflows:

```yaml
  AWS_ACCESS_KEY_ID: "${{ secrets.AWS_ACCESS_KEY_ID }}"
  AWS_SECRET_ACCESS_KEY: "${{ secrets.AWS_SECRET_ACCESS_KEY }}"
  AWS_DEFAULT_REGION: "<your-region>"
```

You will need to create two new secrets in your repository:

- `AWS_ACCESS_KEY_ID` - Your AWS access key ID
- `AWS_SECRET_ACCESS_KEY` - Your AWS secret access key

You will also need to update the `provider.tf` file to use the AWS backend, the following block should be added to the `terraform` block:

```hcl
  backend "s3" {
    bucket         = "<your-bucket>"
    key            = "demo/terraform.tfstate"
    region         = "<your-region>"
    encrypt        = true
  }
```

</details>

#### Step 4: Push your changes

Push your changes to your repository's `main` branch. This will ensure that the workflows are triggered and you can see the results in your Pull Request.

#### Step 5: Create a Pull Request

Create a new Pull Request with your changes. You will see the **terraform-plan.yml** workflow run and post a comment with the output of `terraform plan`. You can now review the changes and approve the Pull Request.

#### Step 6: Merge the Pull Request

Merge the Pull Request. You will see the **terraform-apply.yml** workflow run and apply the changes to your DNSimple account. You can now check your zone on DNSimple to see the changes.

If you would like to see an example of how you might be able to create a workflow for a mono-repo, you can check out the workflows in this repository [here](../../.github/workflows).

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

You can now create a Pull Request with your changes. You will see the **terraform-plan.yml** workflow run and post a comment with the output of `terraform plan`. You can now review the changes and approve the Pull Request. Merge the Pull Request and you will see the **terraform-apply.yml** workflow run and apply the changes to your DNSimple account. You can now check your zone on DNSimple to see the changes.

### Updating an existing record

Let's say you want to update the `A` record for `local.example.com` to point to `198.162.0.1` instead of `127.0.0.1`. You can do this by updating the `value` attribute in your `main.tf` file:

```hcl
resource "dnsimple_zone_record" "local" {
  domain = "example.com"
  name   = "local"
  type   = "A"
  value  = "198.162.0.1"
}
```

You can now create a Pull Request with your changes. You will see the **terraform-plan.yml** workflow run and post a comment with the output of `terraform plan`. You can now review the changes and approve the Pull Request. Merge the Pull Request and you will see the **terraform-apply.yml** workflow run and apply the changes to your DNSimple account. You can now check your zone on DNSimple to see the changes.

---

## What is next?

Extend your DNS management capabilities by exploring the following resources:

- Improve security and compliance by using HashiCorp Sentinel to enforce policy-as-code with the [DNSimple Terraform Sentinel Demo](../sentinel)
- Register and manage domains with Terraform using the [DNSimple Domains Demo](../domains)
- End-to-end example of using Terraform to provision TLS certificates with DNSimple's Let's Encrypt endpoint using the [DNSimple Terraform TLS Demo](../tls-web-application)
- Learn how to dynamically provision DNS records for Consul services with the [DNSimple Consul Demo](../consul)
