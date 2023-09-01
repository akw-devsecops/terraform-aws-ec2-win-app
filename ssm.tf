resource "aws_ssm_association" "install_code_deploy_agent" {
  count = var.create_codedeploy ? 1 : 0

  association_name = "InstallAWSCodeDeployAgent-${local.fq_app_name}"
  name             = "AWS-ConfigureAWSPackage"

  parameters = {
    action           = "Install"
    name             = "AWSCodeDeployAgent"
    installationType = "In-place update"
  }

  targets {
    key    = "tag:deploygroup"
    values = ["${local.fq_app_name}"]
  }
}

resource "aws_ssm_association" "base_setup" {
  count = var.create_codedeploy ? 1 : 0

  association_name = "BaseSetup-${local.fq_app_name}"
  name             = "AWS-RunPowerShellScript"

  parameters = {
    commands = var.pwsh_cmd
  }

  targets {
    key    = "tag:deploygroup"
    values = ["${local.fq_app_name}"]
  }
}
