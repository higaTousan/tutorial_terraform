provider "aws" {
  region     = var.aws_region
}
variable "aws_region" {
  default = "ap-northeast-1"
}

## VPC
module "vpc_hoge" {
  source         = "./modules/VPC"
  vpc_cidr_block = "10.0.0.0/16"
  vpc_name       = "hogehoge"
}
