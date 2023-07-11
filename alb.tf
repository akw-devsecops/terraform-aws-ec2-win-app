module "alb_http" {
  count = var.create_lb ? 1 : 0

  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = local.fq_app_name

  vpc_id = var.vpc_id
  load_balancer_type = "application"

  subnets         = flatten([
    for key, value in data.aws_subnet.ec2_app : [
        value.id
    ]
  ])

  security_groups = [module.alb_http_sg.security_group_id]

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        for key, value in module.ec2_app :
          key => {
          target_id = value.id,
          port = 80
          }
      }
    }
  ]

  // only for testing
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  # https_listeners = [
  #   {
  #     port               = 443
  #     protocol           = "HTTPS"
  #     certificate_arn    = var.lb_ssl_certificate_id
  #     target_group_index = 0
  #   }
  # ]

#   access_logs = {
#     bucket = "my-access-logs-bucket"
#   }

  tags = {
    Owner       = "user"
    Environment = "${var.env}"
  }
}

module "alb_http_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${local.fq_app_name}-elb"
  description = "Security group for ${local.fq_app_name} ELB"

  vpc_id = var.vpc_id
  
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["https-443-tcp"]
  egress_rules = ["all-all"]
  egress_with_source_security_group_id = [
    {
      from_port   = 80
      to_port     = 443
      protocol    = "tcp"
      description = "HTTP"
      source_security_group_id = module.ec2_app_security_group.security_group_id
    }
  ]
}