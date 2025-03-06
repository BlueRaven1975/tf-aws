data "aws_vpc" "this" {
  default = true
}

resource "aws_default_security_group" "this" {
  egress  = []
  ingress = []
  vpc_id  = data.aws_vpc.this.id
}
