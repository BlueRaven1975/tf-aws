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

variable "db_password" {
  description = "Master password for the RDS instance"
  sensitive   = true
  type        = string
}

variable "db_username" {
  description = "Master username for the RDS instance"
  sensitive   = true
  type        = string
}

variable "ec2_flavour" {
  default     = "docker"
  description = "Flavour of the EC2 instance to be created"
  type        = string
  validation {
    condition     = contains(["docker", "k3s"], var.ec2_flavour)
    error_message = "Invalid EC2 flavour: please specify 'docker' or 'k3s'"
  }
}

variable "middleware_api_key" {
  description = "Middleware.io API key"
  sensitive   = true
  type        = string
}

variable "new_relic_api_key" {
  description = "New Relic API key"
  sensitive   = true
  type        = string
}

variable "region" {
  default     = "eu-central-1"
  description = "AWS region in which the components are to be deployed"
  type        = string
}
