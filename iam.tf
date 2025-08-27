module "iam_user_admin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  create_login_profile = false
  force_destroy        = true
  name                 = "admin"
  policies             = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

module "iam_user_github_actions_sa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  create_login_profile = false
  force_destroy        = true
  name                 = "github-actions-sa"
  policies             = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

module "iam_user_pulumi_sa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  create_login_profile = false
  force_destroy        = true
  name                 = "pulumi-sa"
  policies             = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

module "iam_user_terraform_sa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  create_login_profile = false
  force_destroy        = true
  name                 = "terraform-sa"
  policies             = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}
