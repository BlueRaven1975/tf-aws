module "s3_bucket_config" {
  source = "terraform-aws-modules/s3-bucket/aws"

  attach_policy = true
  bucket_prefix = "config-recorder-"
  force_destroy = true

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AWSConfigBucketPermissionsCheck",
        "Effect": "Allow",
        "Principal": {
          "Service": "config.amazonaws.com"
        },
        "Action": "s3:GetBucketAcl",
        "Resource": "${module.s3_bucket_config.s3_bucket_arn}",
        "Condition": { 
          "StringEquals": {
            "AWS:SourceAccount": "${data.aws_caller_identity.current.account_id}"
          }
        }
      },
      {
        "Sid": "AWSConfigBucketExistenceCheck",
        "Effect": "Allow",
        "Principal": {
          "Service": "config.amazonaws.com"
        },
        "Action": "s3:ListBucket",
        "Resource": "${module.s3_bucket_config.s3_bucket_arn}",
        "Condition": { 
          "StringEquals": {
            "AWS:SourceAccount": "${data.aws_caller_identity.current.account_id}"
          }
        }
      },
      {
        "Sid": "AWSConfigBucketDelivery",
        "Effect": "Allow",
        "Principal": {
          "Service": "config.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "${module.s3_bucket_config.s3_bucket_arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*",
        "Condition": { 
          "StringEquals": { 
            "s3:x-amz-acl": "bucket-owner-full-control",
            "AWS:SourceAccount": "${data.aws_caller_identity.current.account_id}"
          }
        }
      }
    ]
  }
  EOF
}
