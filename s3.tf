module "s3_account_block_public_access" {
  source  = "terraform-aws-modules/s3-bucket/aws//modules/account-public-access"
  version = "4.11.0"

  account_id              = data.aws_caller_identity.current.account_id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
