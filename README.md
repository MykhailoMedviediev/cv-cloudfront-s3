# Personal CV Hosting on AWS with Terraform

This repository contains my personal CV in HTML and the Terraform code needed to deploy it to AWS cloud. It creates an S3 bucket for file storage and a CloudFront distribution to serve the HTML securely over HTTPS.

---

## Table of Contents

- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Deployment Instructions](#deployment-instructions)
- [Example Output](#example-output)
- [Teardown](#teardown)
- [Security Considerations](#security-considerations)
- [Notes](#notes)

---

## Project Structure

```
.
├── main.tf               # Defines the main infrastructure resources: an S3 bucket, an S3 object, and a CloudFront distribution
├── locals.tf             # Contains local variables, including tags, CloudFront origin ID, and common method sets
├── outputs.tf            # Outputs the CloudFront distribution URL
├── providers.tf          # Specifies the AWS provider and its region
├── terraform.tf          # Defines required Terraform version and provider constraints
├── index.html            # The static HTML file to be hosted on S3 and served via CloudFront
├── .terraform.lock.hcl   # Terraform dependency lock file
├── .gitignore
└── README.md
```

---

## Prerequisites

To deploy this project, ensure you have the following prerequisites:

- [Terraform](https://developer.hashicorp.com/terraform)
- [AWS CLI](https://aws.amazon.com/cli/) configured with:
  - Access Key Id and Secret Access Key
  - Appropriate IAM permissions to manage:
    - S3
    - CloudFront

---

## Deployment Instructions

Follow the steps below to deploy your CV to AWS:

```bash
# 1. Initialize Terraform
terraform init

# 2. Preview the changes that Terraform plans to make to cloud
terraform plan

# 3. Apply the changes to deploy infrastructure
terraform apply
```

Terraform will output the CloudFront URL upon successful deployment (see [Example Output](#example-output)). This is the public URL where the CV will be hosted.

---

## Example Output

Below is an example of the output from a successful `terraform apply`:

```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

cloudfront_url = "https://dwzecsedkkkjv.cloudfront.net"
```

---

## Teardown

To destroy all infrastructure provisioned by this project:

```bash
terraform destroy
```

---

## Security Considerations

- The S3 bucket policy restricts access to CloudFront only.
- All traffic is served via HTTPS using the default CloudFront SSL certificate.
- This is a minimal setup. Additional features such as logging, a custom domain, or DNS routing via Route 53 can be added as needed.

---

## Notes

- `index.html` must remain in the repository root to match the `aws_s3_object` Terraform object source path.
- This is a minimal setup. Additional features like logging, custom domain, or DNS routing (via Route 53) can be added if needed.
