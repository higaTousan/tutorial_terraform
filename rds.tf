data "aws_security_group" "ec2" {

    tags = {
        Name = "${var.environment}-${var.ec2_private_sg_name}"
    }

    filter {
        name   = "vpc-id"
        values = ["${data.aws_vpc.main.id}"]
    }
}
module "db_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "${var.environment}-${var.db_sg_name}"
  description = var.db_sg_description
  vpc_id      = data.aws_vpc.main.id

  ingress_with_source_security_group_id = [
      {
        rule                     = var.db_inbound_rule
        source_security_group_id = "${data.aws_security_group.ec2.id}"
      },
  ]

  egress_rules        = var.db_egress_rules
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = var.db_identifier

  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_storage_size
  
  name     = var.db_name
  username = var.username
  password = var.password
  port     = var.db_port

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.db_sg.this_security_group_id]

  maintenance_window = var.maintenance_window
  backup_window      = var.backup_window

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval = var.monitoring_interval
  monitoring_role_name = var.monitoring_role_name
  create_monitoring_role = var.create_monitoring_role

  # DB subnet group
  subnet_ids = tolist(data.aws_subnet_ids.private.ids) 

  # DB parameter group
  family = var.parameter_group_family

  # DB option group
  major_engine_version = var.major_engine_version

  # Snapshot name upon DB deletion
  final_snapshot_identifier = var.final_snapshot_identifier

  # Database Deletion Protection
  deletion_protection = var.deletion_protection

  parameters = [
    {
      name = "character_set_client"
      value = "utf8"
    },
    {
      name = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}