resource "aws_codedeploy_app" "ec2_app" {
  name             = local.fq_app_name
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "ec2_app" {
  app_name              = aws_codedeploy_app.ec2_app.name
  deployment_group_name = local.fq_app_name
  service_role_arn      = aws_iam_role.code_deploy_role.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "deploygroup"
      type  = "KEY_AND_VALUE"
      value = local.fq_app_name
    }
  }
}
