terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.30"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.2.9"
}
