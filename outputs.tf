output "admin_aws_access_key_id" {
  value = module.iam_user_admin.iam_access_key_id
}

output "admin_aws_secret_access_key" {
  sensitive = true
  value     = module.iam_user_admin.iam_access_key_secret
}

output "github_actions_sa_aws_access_key_id" {
  value = module.iam_user_github_actions_sa.iam_access_key_id
}

output "github_actions_sa_aws_secret_access_key" {
  sensitive = true
  value     = module.iam_user_github_actions_sa.iam_access_key_secret
}

output "pulumi_sa_aws_access_key_id" {
  value = module.iam_user_pulumi_sa.iam_access_key_id
}

output "pulumi_sa_aws_secret_access_key" {
  sensitive = true
  value     = module.iam_user_pulumi_sa.iam_access_key_secret
}

output "terraform_sa_aws_access_key_id" {
  value = module.iam_user_terraform_sa.iam_access_key_id
}

output "terraform_sa_aws_secret_access_key" {
  sensitive = true
  value     = module.iam_user_terraform_sa.iam_access_key_secret
}
