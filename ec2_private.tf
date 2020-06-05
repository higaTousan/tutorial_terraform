data "aws_vpc" "main" {
  tags = {
    Name = "${var.environment}-${var.vpc_name}"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    SubnetZone = var.private_subnet_zone
  }
}

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

module "ec2_private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "${var.environment}-${var.ec2_private_sg_name}"
  description = var.ec2_private_description
  vpc_id      = data.aws_vpc.main.id

  ingress_cidr_blocks = var.ec2_private_inbound_cidr
  ingress_rules       = var.ec2_private_inbound_rule
  egress_rules        = var.ec2_private_egress_rules
}

module "ec2_private" {
  source = "terraform-aws-modules/ec2-instance/aws"
  instance_count              = var.instances_number_private
  name                        = "${var.environment}-${var.instance_name_private}"
  ami                         = data.aws_ami.amazon_linux2.id
  instance_type               = var.instance_type_private
  subnet_ids                  = tolist(data.aws_subnet_ids.private.ids) 
  vpc_security_group_ids      = [module.ec2_private_sg.this_security_group_id]
  associate_public_ip_address = true
}

resource "aws_volume_attachment" "this_ec2" {
  count = var.instances_number_private

  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this[count.index].id
  instance_id = module.ec2_private.id[count.index]
}

resource "aws_ebs_volume" "this" {
  count = var.instances_number_private

  availability_zone = module.ec2_private.availability_zone[count.index]
  size              = 1
}