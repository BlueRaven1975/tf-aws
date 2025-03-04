module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami_ssm_parameter           = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
  create_iam_instance_profile = true
  iam_role_name               = var.ec2_flavour == "docker" ? "app-server" : "k3s-cluster"

  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  iam_role_use_name_prefix = false
  instance_type            = "t3.micro"
  key_name                 = module.key_pair.key_pair_name

  metadata_options = {
    "http_endpoint" : "enabled",
    "http_put_response_hop_limit" : 1,
    "http_tokens" : "required"
  }

  name = var.ec2_flavour == "docker" ? "app-server" : "k3s-cluster"

  user_data = templatefile(
    var.ec2_flavour == "docker" ? "${path.module}/scripts/user-data-docker.sh" : "${path.module}/scripts/user-data-k3s.sh",
    {
      cloudns_api_key    = var.cloudns_api_key
      k3s_host           = var.k3s_host
      middleware_api_key = var.middleware_api_key
      new_relic_api_key  = var.new_relic_api_key
    }
  )

  user_data_replace_on_change = true
  vpc_security_group_ids      = [module.ec2_sg.security_group_id]
}

module "ec2_sg" {
  source = "terraform-aws-modules/security-group/aws"

  description         = "Application server security group"
  egress_rules        = ["all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]

  ingress_with_cidr_blocks = [
    {
      cidr_blocks = "0.0.0.0/0"
      description = "Go hello-world app"
      from_port   = 8080
      protocol    = "tcp"
      to_port     = 8080
    },
    {
      cidr_blocks = "0.0.0.0/0"
      description = "Python hello-world app"
      from_port   = 8081
      protocol    = "tcp"
      to_port     = 8081
    },
  ]

  name            = "app-server-sg"
  use_name_prefix = false
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "github-actions-sa"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILEjM0Q63fJB2vvWAsAaZt3By6XS1pW2wCUBlFDqbnzd github-actions-sa"
}
