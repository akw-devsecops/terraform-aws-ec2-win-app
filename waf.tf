resource "aws_wafv2_web_acl_association" "this" {
  count = var.create_lb && var.web_acl_arn != "" ? 1 : 0

  resource_arn = module.alb_http[0].lb_arn
  web_acl_arn  = var.web_acl_arn
}
