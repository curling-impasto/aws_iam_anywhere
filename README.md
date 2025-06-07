# Terraform Module: AWS IAM Anywhere Trust Anchor

This Terraform module creates an **AWS IAM Identity Center Anywhere Trust Anchor**, adds a profile to the trust anchor, and provisions the necessary IAM role. The trust anchor uses a private certificate (provided by you) to enable secure, certificate-based authentication for non-human workloads (such as CI/CD agents, bots, or automated systems) to access AWS.

## Features

- **Creates an IAM Identity Center Anywhere Trust Anchor**
- **Adds a profile to the trust anchor in AWS IAM Anywhere**
- **Creates an IAM role for non-human workloads**
- **Uses a user-provided private certificate for authentication**
- **Enables secure login to AWS for non-human workloads using X.509 certificates**


## How it Works

1. **Trust Anchor Creation**:
   The module provisions a trust anchor in AWS IAM Identity Center Anywhere using the provided private certificate.

2. **Profile Addition**:
   It adds a profile to the trust anchor, specifying access boundaries and permissions for workloads authenticating via this anchor.

3. **IAM Role Creation**:
   An IAM role is created and configured to trust the identity provider (the trust anchor). Attach any additional policies as needed.

4. **Certificate-based Authentication**:
   Non-human workloads can use the private certificate to authenticate against AWS via IAM Anywhere, gaining temporary credentials to assume the provisioned IAM role.

## Example: Using the Role with AWS CLI

After configuring the trust anchor, profile, and role, non-human workloads can use the certificate to authenticate with AWS. Refer to the [AWS IAM Identity Center Anywhere documentation](https://docs.aws.amazon.com/singlesignon/latest/IdentityCenterOnboardingGuide/iam-anywhere.html) for details on client setup.

## Prerequisites

- AWS account with IAM Identity Center Anywhere enabled
- A valid X.509 certificate (private key and certificate chain)
- Terraform v1.3 or later
- Appropriate permissions to manage IAM and IAM Anywhere resources
