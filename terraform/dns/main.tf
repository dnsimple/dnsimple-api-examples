terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }

    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = "1.2.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "aws-sydney"
  region = "ap-southeast-2"
}

provider "dnsimple" {
}

variable "domain" {
  type = string
}

// To demonstrate MX and TXT records and how you may use these with mail services, we'll set up AWS SES for our domain. First, we'll verify and set up our domain entirely within Terraform — no manual copy-and-pasting necessary. Then, we'll do some basic SES configuration to store incoming emails to our domain into an S3 bucket, so we can actually do something useful with this mail service setup.

// Create our domain with SES. It won't be verified yet — we'll do that next.
resource "aws_ses_domain_identity" "domain" {
  domain = var.domain
}

// We need to verify our domain, so SES knows we are the true owners of the domain. This involves a simple TXT record, which we can set using the DNSimple zone record resource.
resource "dnsimple_zone_record" "verification_record" {
  zone_name = var.domain
  name      = "_amazonses"
  type      = "TXT"
  ttl       = 600
  value     = aws_ses_domain_identity.domain.verification_token
}

// Now that the record has been set, we'll ask SES to verify and domain and wait for its confirmation. This may take a few minutes...
resource "aws_ses_domain_identity_verification" "domain" {
  domain     = aws_ses_domain_identity.domain.id
  depends_on = [dnsimple_zone_record.verification_record]
}

// For this demo, we'll simply store all incoming emails in our S3 bucket, so lets create one now. SES can do more with incoming emails; see https://docs.aws.amazon.com/ses/latest/dg/receiving-email-concepts.html for more details.
resource "aws_s3_bucket" "emails" {
  bucket = "${var.domain}-emails"
}

// This sets the policy for the S3 bucket we've just created to allow SES to write to it. See more details at https://docs.aws.amazon.com/ses/latest/dg/receiving-email-permissions.html#receiving-email-permissions-s3.
resource "aws_s3_bucket_policy" "emails" {
  bucket = aws_s3_bucket.emails.id
  policy = jsonencode(templatefile("iam/emails-bucket-policy.json", {
    domain = var.domain,
  }))
}

// A rule set tells SES what to do with incoming emails, with one or more rules. We'll create the only rule next, but first we need a rule set for the rule to be created into.
resource "aws_ses_receipt_rule_set" "main" {
  rule_set_name = "main"
}

// We only need one rule in our rule set: store incoming emails to our S3 bucket.
resource "aws_ses_receipt_rule" "main" {
  depends_on    = [aws_s3_bucket_policy.emails]
  name          = "main"
  rule_set_name = aws_ses_receipt_rule_set.main.rule_set_name
  enabled       = true
  s3_action {
    bucket_name = "${var.domain}-emails"
    // If you have more than one action, you can decide the order they're applied in by changing this attribute.
    position = 1
  }
}

// Now that we have set up our rule set with all the rules we need, make the rule set active.
resource "aws_ses_active_receipt_rule_set" "main" {
  rule_set_name = aws_ses_receipt_rule_set.main.rule_set_name
}

// The last thing to do is to set up the MX record for our domain.
// You can see that we've set up an entire mail inbox for our domain, including verification, completely within the same flow in the same Terraform script.
resource "dnsimple_zone_record" "mx_record" {
  zone_name = var.domain
  name      = ""
  type      = "MX"
  ttl       = 600
  priority  = 10
  value     = "inbound-smtp.us-east-1.amazonaws.com"
}

// Now that we have some data (emails stored in our S3 bucket), we'll create an API to expose this information for our app (which we'll set up later). This is a common pattern for many projects and part of most infrastructure. We'll use EC2 instances to host our API server, and see how we can quickly set up the DNS plumbing to get our service up and running rapidly, right here in Terraform.

// First, we need to create a role that will allow our instances to read the emails in our bucket.
resource "aws_iam_role" "api" {
  name = "api"

  inline_policy {
    name = "main"
    policy = jsonencode(templatefile("iam/api-permissions.json", {
      domain = var.domain,
    }))
  }

  // Allow our EC2 instances (which we'll create later) to assume this role.
  assume_role_policy = jsonencode(file("iam/api-role-assume.json"))
}

// We'll create an instance profile so that instances can assume the role we've just created. Learn more about them at https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html.
resource "aws_iam_instance_profile" "api" {
  name = "api"
  role = aws_iam_role.api.name
}

// Now, we can create the instances and deploy our API service. We'll use a simple mechanism to deploy and run the service, which is to simply copy the Python code into our cloud-init script and run it immediately and indefinitely when our instance starts up. You can learn more about cloud-init at https://cloud-init.io/.
// As our API server listens on port 80 (plaintext HTTP), ensure this server can be reached publicly over port 80, so adjust any VPC, subnet, and NSG attributes as necessary. WARNING: Because this is unencrypted, for the purposes of this demo, don't send any private or sensitive information via email to this domain!
// Also, if you'd like to set up SSH access, make sure to provide `key_name`.
resource "aws_instance" "api-virginia" {
  // As of 2023-09-18, this is the AMI ID for Amazon Linux 2013 (x86) in us-east-1.
  ami                         = "ami-04cb4ca688797756f"
  associate_public_ip_address = true
  instance_type               = "t3a.micro"
  iam_instance_profile        = aws_iam_instance_profile.api.name
  user_data                   = templatefile("cloud-init.sh", {
    code = templatefile("api.py", { domain = var.domain }),
  })
}

// Create the A record for our API server in Virginia.
resource "dnsimple_zone_record" "api_virginia_record" {
  zone_name = var.domain
  name      = "api"
  type      = "A"
  ttl       = 600
  value     = aws_instance.api-virginia.public_ip
}

// To demonstrate regional records, we'll spin up a replica API server in Sydney. It runs the same API server and will serve identical data, but will provide a lower latency experience for users in Australia.
resource "aws_instance" "api-sydney" {
  provider = aws.aws-sydney
  // As of 2023-09-18, this is the AMI ID for Amazon Linux 2013 (x86) in ap-southeast-2.
  ami                         = "ami-0dfb78957e4edea0c"
  associate_public_ip_address = true
  instance_type               = "t3a.micro"
  iam_instance_profile        = aws_iam_instance_profile.api.name
  user_data                   = templatefile("cloud-init.sh", {
    code = templatefile("api.py", { domain = var.domain }),
  })
}

// Since all DNSimple DNS record types and features are supported using the Terraform Provider, we can trivially set up a regional record with ease. This provides a simple and flexible way to deploy multi-region infrastructure, whether it's multi-master, geo-replication, or something else, without leaving Terraform.
resource "dnsimple_zone_record" "api_sydney_record" {
  zone_name = var.domain
  name      = "api"
  type      = "A"
  ttl       = 600
  value     = aws_instance.api-sydney.public_ip
  regions   = ["SYD"]
}

// Now that we have our API service up and running, it's time for the final part of our stack: the client. For simplicity, our client is a simple single-page HTML app with some light JavaScript, so we can use a single S3 bucket to serve the HTML over the Internet. Feel free to substitute this section with the client component in your system or architecture.

// Create the bucket for hosting the app.
resource "aws_s3_bucket" "app" {
  bucket = var.domain
}

// Unblock public access, so anyone can reach our app.
resource "aws_s3_bucket_public_access_block" "app" {
  bucket                  = aws_s3_bucket.app.bucket
  block_public_policy     = false
  restrict_public_buckets = false
}

// Set up the bucket policy so that anyone can reach our app.
// See https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteAccessPermissionsReqd.html for more details.
resource "aws_s3_bucket_policy" "app" {
  // We must wait for `block_public_policy` to be disabled.
  depends_on = [aws_s3_bucket_public_access_block.app]
  bucket     = aws_s3_bucket.app.bucket
  policy = jsonencode(templatefile("iam/app-bucket-policy.json", {
    domain = var.domain,
  }))
}

// Configure the bucket to behave like a website. To learn more about this S3 feature, see https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html.
resource "aws_s3_bucket_website_configuration" "app" {
  bucket = aws_s3_bucket.app.bucket
  index_document {
    suffix = "index.html"
  }
}

// Upload our app to the bucket.
resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.app.bucket
  key          = "index.html"
  source       = "app.html"
  content_type = "text/html"
  etag         = filemd5("app.html")
}

// We want users to be able to reach our app via our domain directly for user friendliness (e.g. myapp.com, not www.myapp.com or myapp.com.s3-website-us-east-1.amazonaws.com). However, S3 requires us to point our domain to an *.amazonaws.com domain in order to use the website feature, which means a CNAME record, but that's not allowed at the root by the DNS standard. Therefore, we can take advantage of a DNSimple feature called ALIAS records, which you can read more about at https://support.dnsimple.com/articles/alias-record. We can use these with the Terraform provider.
resource "dnsimple_zone_record" "app" {
  zone_name = var.domain
  name      = ""
  type      = "ALIAS"
  ttl       = 600
  value     = aws_s3_bucket_website_configuration.app.website_endpoint
}

// In case a user goes to `www.myapp.com`, we want them to redirect to `myapp.com` which is where our app is actually hosted. We don't need any additional resources or infrastructure to do this, we can simply take advantage of URL records, another DNSimple feature, right within Terraform.
resource "dnsimple_zone_record" "app_www" {
  zone_name = var.domain
  name      = "www"
  type      = "URL"
  ttl       = 600
  value     = "http://${var.domain}"
}

// Now we have completed the demo and set up all of our infrastructure! You can now try it out and play around. Try sending an email to your domain with any user (e.g. `hello@myapp.com`), and then visit your app. After a few seconds, the email should show up in the list.
