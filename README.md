# Windows EC2 Application Module
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_http"></a> [alb\_http](#module\_alb\_http) | terraform-aws-modules/alb/aws | ~> 8.0 |
| <a name="module_ec2_app"></a> [ec2\_app](#module\_ec2\_app) | terraform-aws-modules/ec2-instance/aws | ~> 4.0 |
| <a name="module_ec2_app_security_group"></a> [ec2\_app\_security\_group](#module\_ec2\_app\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |
| <a name="module_s3_codedeploy"></a> [s3\_codedeploy](#module\_s3\_codedeploy) | terraform-aws-modules/s3-bucket/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_codedeploy_app.ec2_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_group.ec2_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_ebs_volume.ec2_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_iam_instance_profile.ec2_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.ec2_read_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ec2_read_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_codedeploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.code_deploy_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ec2_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.code_deploy_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ec2_app_amazon_ssm_managed_instance_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ec2_app_ec2_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ec2_app_s3_codedeploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ec2_app_ssm_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.ec2_app_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group_rule.rdp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_association.base_setup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_ssm_association.install_code_deploy_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_ssm_parameter.ec2_app_admin_pw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.ec2_app_private_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_volume_attachment.ec2_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [aws_wafv2_web_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [tls_private_key.ec2_app_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.amazon_ssm_managed_instance_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.code_deploy_role_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2_read_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2_read_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_codedeploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.ec2_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | n/a | `string` | n/a | yes |
| <a name="input_create_lb"></a> [create\_lb](#input\_create\_lb) | n/a | `bool` | n/a | yes |
| <a name="input_ec2_instances"></a> [ec2\_instances](#input\_ec2\_instances) | n/a | <pre>map(object({<br>    ami                 = optional(string) # "ami-0cf9380844da84d7e" # Microsoft Windows Server 2022 Base <br>    ec2_instance_type   = optional(string) # "t3.medium"<br>    root_block_size     = optional(number) # 60<br>    secondary_disk_size = optional(number) # 40<br>    subnet_name         = string<br>    tags                = optional(map(string))<br>  }))</pre> | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_pwsh_cmd"></a> [pwsh\_cmd](#input\_pwsh\_cmd) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |
| <a name="input_attach_waf_to_alb"></a> [attach\_waf\_to\_alb](#input\_attach\_waf\_to\_alb) | n/a | `bool` | `true` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | n/a | `string` | `""` | no |
| <a name="input_create_codedeploy"></a> [create\_codedeploy](#input\_create\_codedeploy) | Specifies if to deploy codedeploy | `bool` | `true` | no |
| <a name="input_enable_rdp_access"></a> [enable\_rdp\_access](#input\_enable\_rdp\_access) | Determines whether to have RDP access | `bool` | `false` | no |
| <a name="input_internal_lb"></a> [internal\_lb](#input\_internal\_lb) | n/a | `bool` | `false` | no |
| <a name="input_lb_security_group_rules"></a> [lb\_security\_group\_rules](#input\_lb\_security\_group\_rules) | n/a | `any` | `{}` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | n/a | `list(string)` | `[]` | no |
| <a name="input_rdp_access_cidr_ranges"></a> [rdp\_access\_cidr\_ranges](#input\_rdp\_access\_cidr\_ranges) | Limit RDP access to specific CIDR ranges | `set(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_sg_cidr_range"></a> [sg\_cidr\_range](#input\_sg\_cidr\_range) | n/a | `string` | `""` | no |
| <a name="input_web_acl_arn"></a> [web\_acl\_arn](#input\_web\_acl\_arn) | The Amazon Resource Name (ARN) of the Web ACL that you want to associate with the resource | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->