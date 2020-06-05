data "aws_ami" "amazon_linux2" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"
  instance_count              = 1
  name                        = "test-ec2"
  ami                         = data.aws_ami.amazon_linux2.image_id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.test-subnet.id
}