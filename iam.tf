# CodeDeploy
data "aws_iam_policy_document" "code_deploy_role_assume" {
  count = var.create_codedeploy ? 1 : 0

  version = "2012-10-17"
  statement {
    sid    = "AssumeFromCodeDeploy"
    effect = "Allow"
    principals {
      identifiers = ["codedeploy.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "code_deploy_role" {
  count = var.create_codedeploy ? 1 : 0

  name               = "${local.fq_app_name}-CodeDeployRole"
  assume_role_policy = data.aws_iam_policy_document.code_deploy_role_assume.json
}

resource "aws_iam_role_policy_attachment" "code_deploy_role" {
  count = var.create_codedeploy ? 1 : 0
  
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.code_deploy_role.name
}

# EC2
data "aws_iam_policy_document" "ec2_assume_role" {
  version = "2012-10-17"

  statement {
    sid     = "AllowEC2Assume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy" "amazon_ssm_managed_instance_core" {
  name = "AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "ec2_read_ssm" {
  version = "2012-10-17"

  statement {
    sid       = "ReadSSM"
    effect    = "Allow"
    actions   = ["ssm:GetParametersByPath"]
    resources = ["arn:aws:ssm:eu-central-1:${data.aws_caller_identity.current.account_id}:parameter/*"]
  }
}

resource "aws_iam_policy" "ec2_read_ssm" {
  name        = "ec2_read_ssm_${local.fq_app_name}"
  description = "Policy to access ssm parameters"
  policy      = data.aws_iam_policy_document.ec2_read_ssm.json
}

data "aws_iam_policy_document" "ec2_read_ec2" {
  version = "2012-10-17"

  statement {
    sid    = "ReadEC2"
    effect = "Allow"
    actions = [
      "ec2:DescribeVolumes",
      "ec2:DescribeTags"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_read_ec2" {
  name        = "ec2_read_ec2_${local.fq_app_name}"
  description = "Policy to access EC2"
  policy      = data.aws_iam_policy_document.ec2_read_ec2.json
}
