terraform {
  backend "s3" {
    bucket = "commonservices-tfstate"
    key    = "iam-role-anywhere.state"
    region = "us-east-1"
  }
}
