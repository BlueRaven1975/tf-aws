variable "aws_access_key_id" {
  description = "AWS access key ID"
  sensitive   = true
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  sensitive   = true
  type        = string
}
