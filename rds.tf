module "db" {
  source = "terraform-aws-modules/rds/aws"

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
}
