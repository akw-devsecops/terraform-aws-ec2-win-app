locals {
  # set defaults for object map from vars
  ec2_instances = {
    for k, v in var.ec2_instances : k => {
      ami = coalesce(v.ami, "ami-0cf9380844da84d7e")
      ec2_instance_type = coalesce(v.ec2_instance_type, "t3.medium")
      root_block_size = coalesce(v.root_block_size, 60)
      secondary_disk_size = coalesce(v.secondary_disk_size, 60)
      subnet_name = v.subnet_name
      tags = v.tags
    }
  }

  fq_app_name = "${var.app_name}-${var.env}"
}