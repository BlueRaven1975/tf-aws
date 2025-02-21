module "ec2" {
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
    
    # Install Docker
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user

    # Install Docker Compose
    curl -fsSL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) -o /usr/local/bin/docker-compose
    chmod 0755 /usr/local/bin/docker-compose

    # Install MySQL client
    yum install -y mariadb105

    # Make sudo log all commands
    sed -i '/Defaults    secure_path/a Defaults    logfile=/var/log/sudo.log' /etc/sudoers

    # Install Middleware.io host agent
    MW_API_KEY=${var.middleware_api_key} MW_TARGET=https://bivcm.middleware.io:443 bash -c "$(curl -L https://install.middleware.io/scripts/rpm-install.sh)"

    # Install New Relic infrastructure agent
    echo "license_key: ${var.new_relic_api_key}" | tee -a /etc/newrelic-infra.yml
    curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/amazonlinux/2023/x86_64/newrelic-infra.repo
    yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
    yum install newrelic-infra -y

    # Forward log files to New Relic 
    tee /etc/newrelic-infra/logging.d/logging.yml > /dev/null <<-EOT
    logs:
      - name: sshd
        systemd: sshd
        pattern: publickey|session

      - name: sudo
        file: /var/log/sudo.log
    EOT

    # Update my DDNS address
    curl -s https://ipv4.cloudns.net/api/dynamicURL/?q=ODg3ODIxNjo1NzU4NTQ5NDY6YjllYWRlMDQ2MTFmYjFkOTY3MDg2OWE5YjdiNjhlYjkwZjI2ODU4YjZkYThlNjhiNmE5OGYzM2U3NzkzMTcwYg
  EOF

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
