resource "aws_vpc" "test-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "test-vpc"
  }
}

output "test-vpc_aws_vpc" {
	value = aws_vpc.test-vpc.id
}
