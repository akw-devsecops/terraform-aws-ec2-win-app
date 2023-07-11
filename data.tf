data "aws_caller_identity" "current" {}

data "aws_subnet" "ec2_app" {
  for_each = local.ec2_instances
  
  filter {
    name   = "tag:Name"
    values = ["${each.value.subnet_name}"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}