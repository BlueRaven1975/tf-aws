output "admin_aws_access_key_id" {
  value = module.iam_user_admin.iam_access_key_id
}

output "admin_aws_secret_access_key" {
  sensitive = true
  value     = module.iam_user_admin.iam_access_key_secret
}
