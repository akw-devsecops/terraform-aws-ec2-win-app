module "s3_codedeploy" {
  count = var.create_codedeploy ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = "${local.fq_app_name}-codedeploy"

  attach_deny_insecure_transport_policy = true

  tags = {
    role = "storage"
  }
}

data "aws_iam_policy_document" "s3_codedeploy" {
  count = var.create_codedeploy ? 1 : 0

  version = "2012-10-17"

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${module.s3_codedeploy[0].s3_bucket_arn}/*"]
  }
}

resource "aws_iam_policy" "s3_codedeploy" {
  count = var.create_codedeploy ? 1 : 0

  name        = "s3_codedeploy_${local.fq_app_name}"
  description = "Policy to access the ${local.fq_app_name}-codedeploy bucket"
  policy      = data.aws_iam_policy_document.s3_codedeploy[0].json
}
