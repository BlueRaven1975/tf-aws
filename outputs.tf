output "admin_aws_access_key_id" {
  value = module.iam_user_admin.access_key_id
}

output "admin_aws_secret_access_key" {
  sensitive = true
  value     = module.iam_user_admin.access_key_secret
}

output "github_actions_sa_aws_access_key_id" {
  value = module.iam_user_github_actions_sa.access_key_id
}

output "github_actions_sa_aws_secret_access_key" {
  sensitive = true
  value     = module.iam_user_github_actions_sa.access_key_secret
}

output "pulumi_sa_aws_access_key_id" {
  value = module.iam_user_pulumi_sa.access_key_id
}

output "pulumi_sa_aws_secret_access_key" {
  sensitive = true
  value     = module.iam_user_pulumi_sa.access_key_secret
}

output "terraform_sa_aws_access_key_id" {
  value = module.iam_user_terraform_sa.access_key_id
}

output "terraform_sa_aws_secret_access_key" {
  sensitive = true
  value     = module.iam_user_terraform_sa.access_key_secret
}
