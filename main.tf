# Budgets
resource "aws_budgets_budget" "this" {
  budget_type  = "COST"
  limit_amount = "1"
  limit_unit   = "USD"
  name         = "My personal AWS account budget"

  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["romano.romano@gmail.com"]
    threshold                  = var.budget_threshold
    threshold_type             = "ABSOLUTE_VALUE"
  }

  time_unit = "MONTHLY"
}
