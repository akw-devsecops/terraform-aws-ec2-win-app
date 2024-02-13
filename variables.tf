variable "env" {
  type = string
}

variable "app_name" {
  type = string
}

variable "sg_cidr_range" {
  type    = string
  default = ""
}

variable "create_lb" {
  type = bool
}

variable "internal_lb" {
  type    = bool
  default = false
}

variable "lb_security_group_rules" {
  type    = any
  default = {}
}

variable "create_codedeploy" {
  description = "Specifies if to deploy codedeploy"
  type        = bool
  default     = true
}

variable "certificate_arn" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type = string
}

variable "pwsh_cmd" {
  type = string
}

variable "public_subnets" {
  type    = list(string)
  default = []
}

variable "ec2_instances" {
  type = map(object({
    ami                 = optional(string) # "ami-0cf9380844da84d7e" # Microsoft Windows Server 2022 Base 
    ec2_instance_type   = optional(string) # "t3.medium"
    root_block_size     = optional(number) # 60
    secondary_disk_size = optional(number) # 40
    subnet_name         = string
    tags                = optional(map(string))
  }))
}

variable "enable_rdp_access" {
  description = "Determines whether to have RDP access"
  type        = bool
  default     = false
}

variable "rdp_access_cidr_ranges" {
  description = "Limit RDP access to specific CIDR ranges"
  type        = set(string)
  default     = ["0.0.0.0/0"]
}

variable "web_acl_arn" {
  description = "The Amazon Resource Name (ARN) of the Web ACL that you want to associate with the resource"
  type        = string
  default     = ""
}
