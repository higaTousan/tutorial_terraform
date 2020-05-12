variable "vpc_cidr_block" {}
variable "vpc_name" {}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}