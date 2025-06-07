locals {
  environment         = var.environment
  name                = var.name
  organizational_unit = var.organizational_unit
  common_name         = var.common_name

}

resource "aws_rolesanywhere_trust_anchor" "trust_anchor" {
  name    = "${local.environment}-${local.name}"
  enabled = true
  source {
    source_data {
      x509_certificate_data = file("${path.module}/RootCABundle/RootCA.pem")
    }
    source_type = "CERTIFICATE_BUNDLE"
  }

  lifecycle {
    ignore_changes = [source[0]]
  }
  tags = {
    Owner = "devops"
  }
}

data "aws_iam_policy_document" "rolesanywhere_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:SetSourceIdentity",
      "sts:TagSession"
    ]

    principals {
      type        = "Service"
      identifiers = ["rolesanywhere.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/x509Subject/OU"
      values   = [local.organizational_unit]

    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/x509Subject/CN"
      values   = [local.common_name]
    }

  }
}

resource "aws_iam_role" "roles_anywhere" {
  name               = "${local.environment}-iam-anywhere-role"
  assume_role_policy = data.aws_iam_policy_document.rolesanywhere_assume_role_policy.json

  tags = {
    Owner = "devops"
  }
}


resource "aws_iam_role" "rolesanywhere_app_role" {
  name               = "${local.environment}-app-iam-anywhere-role"
  assume_role_policy = data.aws_iam_policy_document.rolesanywhere_app_role_policy.json
}


resource "aws_iam_policy" "policy_anywhere" {
  name        = "${local.environment}-iam-anywhere-policy"
  description = "Policy allowing all actions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

data "aws_iam_policy_document" "rolesanywhere_app_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:SetSourceIdentity",
      "sts:TagSession"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.roles_anywhere.arn]
    }
  }

}

resource "aws_iam_role_policy_attachment" "roles_anywhere_attach" {
  role       = aws_iam_role.rolesanywhere_app_role.name
  policy_arn = aws_iam_policy.policy_anywhere.arn
}


resource "aws_rolesanywhere_profile" "trust_profile" {

  name      = "${local.environment}-iam-anywhere-profile"
  role_arns = [aws_iam_role.roles_anywhere.arn]

  enabled = true

  session_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": "*",
            "Action": "*"
        }
    ]
}
EOF

}

data "aws_region" "current" {}

resource "local_file" "aws_config_file" {
  content         = <<EOF
[profile login-role-anywhere-${local.environment}]
credential_process = aws_signing_helper credential-process --certificate {TO BE REPLACED WITH CERT} --private-key {TO BE REPLACED WITH PRIVATE KEY} --trust-anchor-arn ${aws_rolesanywhere_trust_anchor.trust_anchor.arn} --profile-arn ${aws_rolesanywhere_profile.trust_profile.arn} --role-arn ${aws_iam_role.roles_anywhere.arn} --with-proxy https://genproxy.corp.amdocs.com:8080

[profile ${local.environment}-programatic]
role_arn       = ${aws_iam_role.rolesanywhere_app_role.arn}
source_profile = login-role-anywhere-${local.environment}
region         = ${data.aws_region.current.name}
    EOF
  filename        = "credentials/${local.environment}-credentials.txt"
  file_permission = "0600"
}
