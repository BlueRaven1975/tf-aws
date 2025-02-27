module "config" {
  source = "cloudposse/config/aws"

  force_destroy                    = true
  global_resource_collector_region = "eu-central-1"
  iam_role_arn                     = aws_iam_service_linked_role.config.arn

  recording_mode = {
    recording_frequency = "DAILY"
  }

  s3_bucket_arn = module.s3_bucket_config.s3_bucket_arn
  s3_bucket_id  = module.s3_bucket_config.s3_bucket_id
}
