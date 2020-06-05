module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "${var.environment}-${var.vpc_name}"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_ipv6 = var.enable_ipv6

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  public_subnet_suffix = var.public_subnet_suffix
  public_subnet_tags = {
    SubnetZone = var.public_subnet_zone
  }

  private_subnet_suffix = var.private_subnet_suffix
  private_subnet_tags = {
    SubnetZone = var.private_subnet_zone
  }

  tags = {
    Environment = var.environment
  }

  vpc_tags = {
    Name = "${var.environment}-${var.vpc_name}"
  }
}