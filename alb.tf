module "alb_http" {
  count = var.create_lb ? 1 : 0

  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = local.fq_app_name

  vpc_id             = var.vpc_id
  load_balancer_type = "application"

  security_group_rules = var.lb_security_group_rules != {} ? var.lb_security_group_rules : {
    ingress_all_http = {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP web traffic"
      cidr_blocks = ["0.0.0.0/0"]
    },
    ingress_all_https = {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS web traffic"
      cidr_blocks = ["0.0.0.0/0"]
    },
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  subnets = var.public_subnets
  internal = var.internal_lb

  target_groups = [
    {
      name_prefix      = "tg-"
      backend_protocol = "HTTPS"
      backend_port     = 443
      target_type      = "instance"
      targets = {
        for key, value in module.ec2_app :
        key => {
          target_id = value.id,
          port      = 443
        }
      }
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  https_listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = var.certificate_arn
    }
  ]

  tags = {
    Owner       = "user"
    Environment = "${var.env}"
  }
}