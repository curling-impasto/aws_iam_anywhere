module "aws_ops_auth" {
  source = "../../modules/iam_roles_anywhere"

  environment         = "dev"
  region              = "us-east-1"
  organizational_unit = "ABC"
  common_name         = "abc.corp.abc.com"
}
