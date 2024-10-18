provider "aws" {
  access_key = var.aws_access_key_id
  default_tags {
    tags = var.aws_default_tags
  }
  region     = var.region
  secret_key = var.aws_secret_access_key
}
