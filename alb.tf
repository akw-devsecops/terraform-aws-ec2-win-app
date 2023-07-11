module "alb_http" {
  count = var.create_lb ? 1 : 0

  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = local.fq_app_name

  vpc_id             = var.vpc_id
  load_balancer_type = "application"

  subnets = var.public_subnets

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