# DNSimple Policy-as-Code with Terraform and Sentinel

Welcome to the DNSimple's Policy-as-Code with Terraform and Sentinel demo. Taking DNS management to a whole new level, this demo unveils the prowess of policy-as-code through the integration of Terraform, Sentinel, and DNSimple's robust DNS and Domain management platform. The fusion of these tools not only streamlines DNS record and Domain management but also enforces policy adherence, ensuring every change is compliant with your organization's standards.

Here's a sneak peek of what you will delve into in this demo:

- Policy-as-Code Paradigm
Experience the embodiment of policy-as-code, enabling the automation of policy enforcement in real-time whenever DNS changes are proposed.

- Real-Time Policy Enforcement
With Sentinel’s policy-as-code framework, enforce organizational and regulatory policies instantly, ensuring every DNS change adheres to the set standards before being applied.

- Version-Controlled Policy Management
Every policy and DNS change is meticulously tracked in your version control system, fostering a culture of accountability and providing a clear audit trail.

- Collaborative Policy Development
Promote cross-functional collaboration in developing, reviewing, and refining policies, breaking down silos, and fostering a shared responsibility towards policy adherence.

- Educational Journey
Whether you are new to Terraform, Sentinel, or DNSimple, this demo provides a guided journey, aiding in grasping the fundamentals and illustrating the practical application of policy-as-code in DNS and Domain management.

By the end of this demo, you'll have a solid understanding of how to utilize Terraform, Sentinel, and DNSimple to establish a policy-driven DNS management framework, empowering your organization to democratize DNS management while ensuring policy adherence.


## Prerequisites

- Two domains that are registered at DNSimple. Don't have an account? [Sign up for free](https://dnsimple.com/sign_up) today!
You can also use the [DNSimple Sandbox](https://developer.dnsimple.com/sandbox/) to test this demo out and get a feel for the platform.
- API access token with write access to the zone. [Create a new token following our support article](https://support.dnsimple.com/articles/api-access-token/). Please take note of the token and your account ID as you will need them later.
- Terraform CLI installed on your machine. You can download the latest version from the [Terraform website](https://www.terraform.io/downloads.html). Alternatively, you can use the .devcontainer in this repository to get up and running quickly.
- GitHub account as this demo uses GitHub Actions to automate the DNS change management process. If you would like to set up a GitOps workflow with GitHub Actions. Alternatively, you can only do the demo locally or directly through Terraform Cloud.
- [Terraform Cloud](https://app.terraform.io/signup/account) account and an API token. You can create a new token in the [Terraform Cloud user settings](https://app.terraform.io/app/settings/tokens). Please take note of the token as you will need it later. This is not optional as you will need to use Terraform Cloud to run the Sentinel policy.

## Getting Started

There are two parts to this demo. The first part is to set up and run the demo locally with Terraform Cloud. The second part is to set up GitHub Actions to automate the DNS change management process.

### Part 1: Run the demo locally with Terraform Cloud

#### Step 1: Clone the repository

Clone this repository to your local machine:

```bash
git clone git@github.com:dnsimple/dnsimple-api-examples.git
cd dnsimple-api-examples/terraform/sentinel
```

#### Step 2: Setup Terraform Cloud

1. Create a new workspace in Terraform Cloud. Select the "API-driven workflow" option.
2. Next, we want to authenticate your local environment with Terraform Cloud. We will do this by setting environment variables as follows:

```bash
export TF_CLOUD_ORGANIZATION="<your organization name>"
export TF_WORKSPACE="<your Terraform Cloud workspace name>"
export TF_TOKEN_app_terraform_io="<your Terraform Cloud API token>"
```

Alternatively, you can authenticate with Terraform Cloud by running `terraform login` and following the prompts. If you take this route you will also need to add the following to your `main.tf` file:

```hcl
terraform {
  cloud {
    organization = "<your organization name>"

    workspaces {
      name = "<your Terraform Cloud workspace name>"
    }
  }
}
```

#### Step 3: Setup the domains we will be using

1. Begin by copying the `terraform.tfvars.example` file to `terraform.tfvars`:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Fill out the `terraform.tfvars` file with the information for the domains you will be using. You will also create these variables at the workspace level in Terraform Cloud.

2. Next, we will import the domains into our Terraform state. Run the following commands:

```bash
terraform init
```

```bash
terraform import dnsimple_registered_domain.domain_a <domain_a>
terraform import dnsimple_registered_domain.domain_b <domain_b>
```

#### Step 4: Setup the Sentinel policy

Create a new policy in Terraform Cloud. Copy the contents of `policies.sentinel` into the policy. You will also need to create a policy set and attach the policy to the policy set. When creating the policy set, you will should select the workspace you created in Step 2, otherwise, the policies will be applied to all workspaces in your organization.

You will need to fill out the following variables in the policy with your own values:

```hcl
allowed_contact_ids = [10169]
```

HINT: To get the contact ID, you can run the following command in the Terraform CLI:

```bash
terraform state show dnsimple_registered_domain.domain_a | grep contact_id
terraform state show dnsimple_registered_domain.domain_b | grep contact_id
```

The policy includes additional variables that you can customize to your liking. For example, you can the enforced state for each of the checks. As well as which domains or TLDs to skip when running the policy.

You will notice that in the policy there are in total 5 separate rules that are being enforced. These rules are:

```hcl
main = rule {
  auto_renew and
  whois_privacy and
  transfer_lock and
  dnssec and
  contact_id and
  domain_delegation
}
```

You can customize the policy to your liking by removing or adding rules.

#### Step 5: Run a Speculative Plan

Now that we have imported the domains and set up the Sentinel policy, we can run a speculative plan to see what changes will be made. Run the following command:

```bash
terraform plan
```

You should expect to see an error message indicating that a policy check failed. This is expected as we have not yet corrected the issues that the policy is flagging.

```bash
## Policy 1: sentinel-demo-policy (hard-mandatory)

Result: false

Print messages:

	========================================================================
 	Name        : policies.sentinel
 	Provider    : dnsimple/dnsimple
 	Resource    : dnsimple_registered_domain
 	Parameter   : whois_privacy_enabled
 	========================================================================
 	For a list of allowed parameter options see:
 	https://github.com/dnsimple/policy-library-dnsimple-terraform/blob/main/README.md

	========================================================================
 	RESOURCE VIOLATIONS
 	The domain whois_privacy_enabled state should be ${whois_privacy_state}
 	========================================================================
	 name       : domain_b
	 type       : dnsimple_registered_domain
	 address    : dnsimple_registered_domain.domain_a
	 message    : false is not an allowed whois_privacy_enabled state.
 	------------------------------------------------------------------------
	 Resources out of compliance: 1
 	------------------------------------------------------------------------

./sentinel-demo-policy.sentinel:305:1 - Rule "main"
  Value:
    false

./sentinel-demo-policy.sentinel:281:1 - Rule "auto_renew"
  Value:
    true

./sentinel-demo-policy.sentinel:285:1 - Rule "whois_privacy"
  Value:
    false


╷
│ Error: Organization Policy Check hard failed.
│
│
╵
```

#### Step 6: Correct the issues

Now that we have seen what issues the policy is flagging, we can correct them. In this case, we will correct the issues by updating the `main.tf` file with the correct values for the `whois_privacy_enabled`.

```hcl
resource "dnsimple_registered_domain" "domain_a" {
  contact_id = var.dnsimple_contact_id
  name       = var.dnsimple_domain_a

  auto_renew_enabled    = true
  dnssec_enabled        = true
  transfer_lock_enabled = true
  whois_privacy_enabled = true
}
```

Next time we run the plan, we should see that the policy check passes.

```bash
Sentinel Result: true

This result means that all Sentinel policies passed and the protected
behavior is allowed.

1 policies evaluated.

## Policy 1: sentinel-demo-policy (hard-mandatory)

Result: true

./sentinel-demo-policy.sentinel:305:1 - Rule "main"
  Value:
    true

./sentinel-demo-policy.sentinel:281:1 - Rule "auto_renew"
  Value:
    true

./sentinel-demo-policy.sentinel:297:1 - Rule "contact_id"
  Value:
    true

./sentinel-demo-policy.sentinel:293:1 - Rule "dnssec"
  Value:
    true

./sentinel-demo-policy.sentinel:301:1 - Rule "domain_delegation"
  Value:
    true

./sentinel-demo-policy.sentinel:289:1 - Rule "transfer_lock"
  Value:
    true

./sentinel-demo-policy.sentinel:285:1 - Rule "whois_privacy"
  Value:
    true
```

### Part 2: Setup GitHub Actions to automate the DNS change management process

In the first part of this demo, we set up the policy and ran a speculative plan to see what changes would be made. In this part, we will set up GitHub Actions to automate the DNS change management process. So that every time a change is made to the Terraform configuration, GitHub Actions will run a speculative plan and report back the results in the form of a pull request comment. This will allow you to review the changes and approve or reject them, all from the comfort of your GitHub repository.

#### Step 1: Create a new GitHub repository

Begin by creating a new GitHub repository. You can name it whatever you like (here is a suggestion `dnsimple-sentinel-demo`). Once you have created the repository, clone it to your local machine.

#### Step 2: Copy the files from this repository to your new repository

Copy the following files from this repository to your new repository:

- `.github/workflows/terraform-plan.yml`
- `.github/workflows/terraform-apply.yml`
- `main.tf`
- `terraform.tfvars.example`
- `variables.tf`
- `provider.tf`
- `.gitignore`
- `policies.sentinel`

#### Step 3: Setup the GitHub repository secrets

In order for the GitHub Actions to run, we need to set the following secrets in the GitHub repository:

- `TF_API_TOKEN`: Terraform Cloud API token
- `TF_CLOUD_ORGANIZATION`: Terraform Cloud organization name
- `TF_WORKSPACE`: Terraform Cloud workspace name

#### Step 4: Commit and push the changes

Commit and push only the following files as the rest of the files will be added in the next step as part of a Pull Request:

```bash
git add .github/workflows .gitignore terraform.tfvars.example
git commit -m 'Initial commit'
git push origin main
```

#### Step 5: Create a Pull Request

Create a branch and commit and push the rest of the files to the branch. Then create a Pull Request. Once the Pull Request is created, you should see the GitHub Actions running. Once the GitHub Actions have been completed, you should see a comment on the Pull Request with the results of the plan. If you would like to see what a failing plan looks like due to a policy check, you can change the `whois_privacy_enabled` to `false` in the `main.tf` file, or any of the other values in the Terraform configuration.

```bash
git checkout -b add-terraform-config
git add main.tf variables.tf provider.tf
```

#### Step 6: Merge the Pull Request

Once you have reviewed the changes and are happy with them, you can merge the Pull Request. Once the Pull Request is merged, you should see the GitHub Actions running again. This time, the GitHub Actions will run the `terraform apply` command and apply the changes to your DNSimple account. You can verify that the changes were applied by checking your DNSimple account and also inspecting the state and run logs in Terraform Cloud.

## Conclusion

Congratulations! You have successfully completed the "DNSimple Policy-as-Code with Terraform and Sentinel" demo. You have learned how to utilize Terraform, Sentinel, and DNSimple to establish a policy-driven DNS management framework, empowering your organization to democratize DNS management while ensuring policy adherence.

When thinking about moving to production and maturing your policy-as-code framework, here are some things to consider:

- **Modularize Policies**: In the current demo we created the policy manually in Terraform Cloud, however, to make the policy more reusable and easier to maintain, you can create a module for each policy and load them as a policy set in Terraform Cloud through version control. This will allow you to easily reuse the policies across multiple workspaces and organizations and also allow you to version control the policies with automated release processes and audit trails.
- **Policy Testing**: As your policy-as-code framework matures, you will want to ensure that your policies are working as expected. You can do this by writing tests for your policies. You can read more about policy testing in the [Sentinel documentation](https://docs.hashicorp.com/sentinel/terraform/testing).
- **Terraform Policies Registry**: All of our policies are available in the Terraform Policies Registry. You can find them [here](https://registry.terraform.io/policies/dnsimple/dnsimple-terraform).

Reach out to us at [support at dnsimple dot com](mailto:support@dnsimple.com) if you have any questions or feedback. We would love to hear from you!

## What is next?

Extend your DNS management capabilities by exploring the following resources:

- Manage DNS records with Terraform using the [DNSimple DNS Records Demo](../dns-change-management)
- Register and manage domains with Terraform using the [DNSimple Domains Demo](../domains)
- End-to-end example of using Terraform to provision TLS certificates with DNSimple's Let's Encrypt endpoint using the [DNSimple Terraform TLS Demo](../tls-web-application)
- Learn how to dynamically provision DNS records for Consul services with the [DNSimple Consul Demo](../consul)
