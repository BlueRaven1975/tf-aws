module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami_ssm_parameter           = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  create_iam_instance_profile = true
  iam_role_name               = "app-server"

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

  name = "app-server"

  user_data = <<-EOF
    #!/bin/bash
    
    # Install Middleware.io host agent
    MW_API_KEY=${var.middleware_api_key} MW_TARGET=https://bivcm.middleware.io:443 bash -c "$(curl -L https://install.middleware.io/scripts/rpm-install.sh)"
  EOF

  user_data_replace_on_change = true
  vpc_security_group_ids      = [module.ec2_instance_sg.security_group_id]
}

module "ec2_instance_sg" {
  source = "terraform-aws-modules/security-group/aws"

  description         = "Application server security group"
  egress_rules        = ["all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "http-80-tcp", "https-443-tcp"]
  name                = "app-server-sg"
  use_name_prefix     = false
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "blueraven"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPagc07GASIeatPDBl3evs1MrC15K13JJrt3P4YzR/v romano.romano@gmail.com"
}
