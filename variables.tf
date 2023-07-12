variable "env" {
  type = string
}

variable "app_name" {
  type = string
}

variable "sg_cidr_range" {
  type = string
  default = ""
}

variable "create_lb" {
  type = bool
}

variable "internal_lb" {
  type = bool
  default = false
}

variable "certificate_arn" {
  type = string
  default = ""
}

variable "vpc_id" {
  type = string
}

variable "pwsh_cmd" {
  type = string
}

variable "public_subnets" {
  type = list(string)
  default = [ ]
}

variable "ec2_instances" {
    type =  map(object({
      ami = optional(string) # "ami-0cf9380844da84d7e" # Microsoft Windows Server 2022 Base 
      ec2_instance_type = optional(string) # "t3.medium"
      root_block_size = optional(number) # 60
      secondary_disk_size = optional(number) # 40
      subnet_name = string
      tags = optional(map(string))
    }))
}

