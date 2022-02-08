variable "aws_region" {
  type    = string
  default = ""
}

variable "my_ip_cidr" {
  type    = string
  default = ""
}

variable "environment_name" {
  type    = string
  default = ""
}

variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}

locals {
  tags = {
    ops_env              = "${var.environment_name}"
    ops_managed_by       = "terraform",
    ops_module_repo      = "kcoconnor/terraform-mbwa-aws",
    ops_module_repo_path = "terraform-mbwa-aws-ec2-mssql-securitygroup",
    ops_owners           = "kcoconnor",
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.environment_name]
  }
}

module "security_group_mssql" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.3.0"

  name        = "${var.environment_name}-mssql"
  description = "MSSQL security group"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP port from VPC/MyPC"
      cidr_blocks = "${data.aws_vpc.vpc.cidr_block_associations[0].cidr_block},${var.my_ip_cidr}"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS port from VPC/MyPC"
      cidr_blocks = "${data.aws_vpc.vpc.cidr_block_associations[0].cidr_block},${var.my_ip_cidr}"
    },
    {
      from_port   = 1433
      to_port     = 1433
      protocol    = "tcp"
      description = "RDS MSSQL port from VPC/MyPC"
      cidr_blocks = "${data.aws_vpc.vpc.cidr_block_associations[0].cidr_block},${var.my_ip_cidr}"
    },
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      description = "RDP port from VPC/MyPC"
      cidr_blocks = "${data.aws_vpc.vpc.cidr_block_associations[0].cidr_block},${var.my_ip_cidr}"
    },
    {
      from_port   = 8443
      to_port     = 8443
      protocol    = "tcp"
      description = "RDS MSSQL port for SSRS"
      cidr_blocks = "${data.aws_vpc.vpc.cidr_block_associations[0].cidr_block},${var.my_ip_cidr}"
    },
    {
      from_port   = 2383
      to_port     = 2383
      protocol    = "tcp"
      description = "RDS MSSQL port for SSAS"
      cidr_blocks = "${data.aws_vpc.vpc.cidr_block_associations[0].cidr_block},${var.my_ip_cidr}"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = merge(local.tags, var.additional_tags, )

}

# Lookup the security group just created
data "aws_security_group" "mssql" {

  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:Name"
    values = ["dev-mssql"]
  }

  depends_on = [
    module.security_group_mssql
  ]

}
