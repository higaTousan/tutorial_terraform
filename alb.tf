module "s3_bucket_for_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.environment}-${var.access_logs_bucket_name}"
  acl    = "private"

  # Allow deletion of non-empty bucket
  force_destroy = true

  attach_elb_log_delivery_policy = true
}

module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "${var.environment}-${var.alb_sg_name}"
  description = var.alb_sg_description
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.alb_sg_inbound_cidr]
  ingress_rules       = [var.alb_sg_inbound_rule]
  egress_rules        = [var.alb_sg_outbound_rule]
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = "${var.environment}-${var.alb_name}"

  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.alb_sg.this_security_group_id]

  access_logs = {
    bucket = "${var.environment}-${var.access_logs_bucket_name}"
  }

  target_groups = [
    {
      name             = "${var.environment}-${var.target_group_name}"
      backend_protocol = var.tg_backend_protocol
      backend_port     = var.tg_backend_port
      target_type      = var.tg_target_type
    }
  ]

#  https_listeners = [
#    {
#     port               = 443
#      protocol           = "HTTPS"
#      certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
#      target_group_index = 0
#   }
#  ]

  http_tcp_listeners = [
    {
      port               = var.http_tcp_listeners_port
      protocol           = var.http_tcp_listeners_protocol
      target_group_index = 0
    }
  ]

  tags = {
    Environment = var.environment
  }
}