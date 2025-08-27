module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.0.0"

  allocated_storage           = 20
  create_db_option_group      = false
  create_db_parameter_group   = false
  engine                      = "mysql"
  engine_version              = "8.0"
  family                      = "mysql8.0"
  identifier                  = "db-server"
  instance_class              = "db.t3.micro"
  major_engine_version        = "8.0"
  manage_master_user_password = false
  password                    = var.db_password
  skip_final_snapshot         = true
  storage_type                = "gp2"
  username                    = var.db_username
  vpc_security_group_ids      = [module.db_sg.security_group_id]
}

module "db_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  description  = "RDS instance security group"
  egress_rules = ["all-all"]

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.ec2_sg.security_group_id

    }
  ]

  name            = "db-sg"
  use_name_prefix = false
}
