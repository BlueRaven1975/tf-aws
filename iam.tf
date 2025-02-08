module "iam_user_admin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  create_iam_user_login_profile = false
  force_destroy                 = true
  name                          = "admin"
  policy_arns                   = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}
