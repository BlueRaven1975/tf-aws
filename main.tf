module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami_ssm_parameter           = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  create_iam_instance_profile = true
  iam_role_name               = "k3s-cluster"

  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  iam_role_use_name_prefix = false
  instance_type            = "t3.micro"
  key_name                 = module.key_pair.key_pair_name
  name                     = "k3s-cluster"

  user_data = <<-EOF
    #!/bin/bash
    # Fetch the public IP of the instance
    PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

    # Install K3s with the public IP as the TLS SAN and kubeconfig file mode set to 644
    curl -sfL https://get.k3s.io | sh -s - server --tls-san $PUBLIC_IP --write-kubeconfig-mode=644
  EOF

  user_data_replace_on_change = true
  vpc_security_group_ids      = [module.ec2_instance_sg.security_group_id]
}

module "ec2_instance_sg" {
  source = "terraform-aws-modules/security-group/aws"

  description         = "K3s cluster security group"
  egress_rules        = ["all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-8080-tcp", "kubernetes-api-tcp", "ssh-tcp"]
  name                = "k3s-cluster-sg"
  use_name_prefix     = false
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "blueraven"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPagc07GASIeatPDBl3evs1MrC15K13JJrt3P4YzR/v romano.romano@gmail.com"
}
