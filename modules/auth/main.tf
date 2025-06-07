locals {
    name = var.name
    country = var.country
    province = var.province
    locality = var.locality
    organization = var.organization
    organizational_unit = var.organizational_unit
    common_name = var.common_name
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "private_key" {
    content  = tls_private_key.private_key.private_key_pem
    filename = "credentials/${local.name}-aws-auth.pem"
    file_permission   = "0600"
}

resource "tls_cert_request" "csr" {
  private_key_pem = tls_private_key.private_key.private_key_pem

  subject {
   country = local.country
   province = local.province
   locality = local.locality
   organization = local.organization
   organizational_unit = local.organizational_unit
   common_name = local.common_name
  }
}

resource "local_sensitive_file" "csr" {
    content  = tls_cert_request.csr.cert_request_pem
    filename = "credentials/${local.name}-aws-auth-csr.pem"
    file_permission   = "0600"
}