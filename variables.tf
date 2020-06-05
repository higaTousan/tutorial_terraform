#######################
## Variable Settings ##
#######################

# Base
variable "environment" {}
variable "region" {}
variable "azs" {
    description = "サブネットを配置するAZ。regionと対応させる必要あり"
    default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

# VPC
variable "vpc_name" {}
variable "vpc_cidr" {}
variable "enable_ipv6" {}
variable "enable_nat_gateway" {}
variable "single_nat_gateway" {}

# Sbunet
variable "public_subnet_zone" {}
variable "public_subnet_suffix" {}
variable "public_subnets" {
    description = "作成するパブリックサブネットCIDR一覧"
    default     = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

variable "private_subnet_zone" {}
variable "private_subnet_suffix" {}
variable "private_subnets" {
    description = "作成するサブネットCIDR一覧"
    default     = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
}

# ALB
variable "alb_name" {}
variable "alb_sg_name" {}
variable "alb_sg_description" {}
variable "alb_sg_inbound_cidr" {}
variable "alb_sg_inbound_rule" {}
variable "alb_sg_outbound_rule" {}
variable "target_group_name" {}
variable "tg_backend_protocol" {}
variable "tg_backend_port" {}
variable "tg_target_type" {}
variable "http_tcp_listeners_port" {}
variable "http_tcp_listeners_protocol" {}
variable "access_logs_bucket_name" {}

# EC2 in PrivateSubnet
variable "instances_number_private" {
    description = "プライベートサブネットに作成するインスタンスの数"
    default = 1
}
variable "instance_type_private" {
    description = "インスタンスタイプ"
    default = "t3.small"
}
variable "instance_name_private" {}
variable "ec2_private_sg_name" {}
variable "ec2_private_description" {}
variable "ec2_private_inbound_cidr" {}
variable "ec2_private_inbound_rule" {}
variable "ec2_private_egress_rules" {}

# RDS
variable "db_sg_name" {}
variable "db_sg_description" {}
variable "db_inbound_rule" {}
variable "db_egress_rules" {}
variable "db_identifier" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_instance_class" {}
variable "db_storage_size" {}
variable "db_name" {}
variable "username" {}
variable "password" {}
variable "db_port" {}
variable "maintenance_window" {}
variable "backup_window" {}
variable "monitoring_interval" {}
variable "monitoring_role_name" {}
variable "create_monitoring_role" {}
variable "deletion_protection" {}
variable "parameter_group_family" {}
variable "major_engine_version" {}
variable "final_snapshot_identifier" {}