module "ec2_app" {
  for_each = local.ec2_instances

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"

  name          = "${each.key}-${var.env}"
  ami           = each.value.ami
  instance_type = each.value.ec2_instance_type

  subnet_id              = data.aws_subnet.ec2_app[each.key].id
  vpc_security_group_ids = [module.ec2_app_security_group.security_group_id]

  key_name             = aws_key_pair.ec2_app_key[each.key].key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_app.name

  get_password_data = true

  root_block_device = [{
    volume_type = "gp3"
    volume_size = each.value.root_block_size
  }]

  tags = merge({
    Server      = "${var.app_name}",
    env         = "${var.env}",
    deploygroup = local.fq_app_name,
    }, each.value.tags
  )
}

resource "tls_private_key" "ec2_app_key" {
  for_each = local.ec2_instances

  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "ec2_app_key" {
  for_each = local.ec2_instances

  key_name   = "ec2_${each.key}_key_${var.env}"
  public_key = tls_private_key.ec2_app_key[each.key].public_key_openssh
}

resource "aws_ssm_parameter" "ec2_app_private_key" {
  for_each = local.ec2_instances

  name  = "/${var.app_name}/${var.env}/${module.ec2_app[each.key].id}/private_key"
  type  = "SecureString"
  value = tls_private_key.ec2_app_key[each.key].private_key_pem
}

resource "aws_ssm_parameter" "ec2_app_admin_pw" {
  for_each = local.ec2_instances

  name  = "/${var.app_name}/${var.env}/${module.ec2_app[each.key].id}/admin_pw"
  type  = "SecureString"
  value = rsadecrypt(module.ec2_app[each.key].password_data, tls_private_key.ec2_app_key[each.key].private_key_pem)
}

module "ec2_app_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.fq_app_name
  description = "Security group for ${local.fq_app_name}"

  vpc_id = var.vpc_id

  ingress_cidr_blocks = var.create_lb == false ? ["${var.sg_cidr_range}"] : []

  ingress_with_source_security_group_id = var.create_lb ? [
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "HTTPS from ALB"
      source_security_group_id = "${module.alb_http[0].security_group_id}"
  }] : []

  ingress_rules = var.create_lb ? [] : ["http-80-tcp", "https-443-tcp"]
  egress_rules  = ["all-tcp", "dns-udp"]
}

resource "aws_security_group_rule" "rdp" {
  count = var.enable_rdp_access ? 1 : 0

  description       = "RDP Access"
  type              = "ingress"
  security_group_id = module.ec2_app_security_group.security_group_id
  protocol          = "tcp"
  from_port         = 3389
  to_port           = 3389
  cidr_blocks       = var.rdp_access_cidr_ranges
}

resource "aws_volume_attachment" "ec2_app" {
  for_each = local.ec2_instances

  device_name = "xvdf"
  volume_id   = aws_ebs_volume.ec2_app[each.key].id
  instance_id = module.ec2_app[each.key].id
}

resource "aws_ebs_volume" "ec2_app" {
  for_each = local.ec2_instances

  availability_zone = data.aws_subnet.ec2_app[each.key].availability_zone
  size              = each.value.secondary_disk_size
  type              = "gp3"

  tags = {
    Name = local.fq_app_name
  }
}

resource "aws_iam_instance_profile" "ec2_app" {
  name = "ec2_${local.fq_app_name}"
  role = aws_iam_role.ec2_app.name
}

resource "aws_iam_role" "ec2_app" {
  name               = "ec2_${local.fq_app_name}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ec2_app_amazon_ssm_managed_instance_core" {
  policy_arn = data.aws_iam_policy.amazon_ssm_managed_instance_core.arn
  role       = aws_iam_role.ec2_app.name
}

resource "aws_iam_role_policy_attachment" "ec2_app_s3_codedeploy" {
  count = var.create_codedeploy ? 1 : 0

  policy_arn = aws_iam_policy.s3_codedeploy[0].arn
  role       = aws_iam_role.ec2_app.name
}

resource "aws_iam_role_policy_attachment" "ec2_app_ssm_read" {
  policy_arn = aws_iam_policy.ec2_read_ssm.arn
  role       = aws_iam_role.ec2_app.name
}

resource "aws_iam_role_policy_attachment" "ec2_app_ec2_read" {
  policy_arn = aws_iam_policy.ec2_read_ec2.arn
  role       = aws_iam_role.ec2_app.name
}
