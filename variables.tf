variable "aws_access_key_id" {
  description = "AWS access key ID"
  sensitive   = true
  type        = string
}

variable "aws_default_tags" {
  default = {
    github_repository = "https://github.com/BlueRaven1975/tf-aws"
    tfe_workspace     = "tf-aws"
  }
  description = "Tags to be applied to all resources created by the code"
  type        = map(string)
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  sensitive   = true
  type        = string
}

variable "budget_threshold" {
  default     = 0.01
  description = "Budget threshold triggering notifications and alerts"
  type        = number
}

variable "middleware_api_key" {
  description = "Middleware.io API key"
  sensitive   = true
  type        = string
}

variable "region" {
  default     = "eu-central-1"
  description = "AWS region in which the components are to be deployed"
  type        = string
}
