variable "aws_region" {
  type    = string
  default = ""
}

variable "environment_name" {
  type    = string
  default = ""
}

variable "windows_admin_password" {
  description = "password for the windows admin"
  type        = string
  sensitive   = true
}

variable "mssql_ami_owner" {
  type    = string
  default = "amazon"
}

variable "mssql_ami_name" {
  type    = string
  default = "Windows_Server-2019-English-Full-SQL_2019_Standard-*"
}

variable "mssql_key_pair_name" {
  type = string
}

variable "mssql_instance_type" {
  type    = string
  default = "t3.xlarge"
}

variable "database_subnets" {
  type        = list(string)
  description = "A list of database subnets"
}

variable "ad_id" {
  type        = string
  description = "The ID of the AD"
  value       = resource.aws_directory_service_directory.ad.id
}

variable "ad_name" {
  type        = string
  description = "The name of the AD"
  value       = var.ad_name
}

variable "ad_dns_ip_addresses" {
  type        = list(string)
  description = "The dns ip addresses of the AD"
  value       = resource.aws_directory_service_directory.ad.dns_ip_addresses
}

variable "aws_security_group_mssql_id" {
  value = data.aws_security_group.mssql.id
}


locals {

  env_title = title("${var.environment_name}")

  tags = {
    ops_env              = "${var.environment_name}"
    ops_managed_by       = "terraform",
    ops_module_repo      = "kcoconnor/terraform-mbwa-aws",
    ops_module_repo_path = "terraform-mbwa-aws-ec2-mssql",
    ops_owners           = "kcoconnor",
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.environment_name]
  }
}

data "aws_subnet_ids" "database" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    subnet_tier = "database"
  }
}

data "aws_ami" "mssql" {
  most_recent = true
  owners      = [var.mssql_ami_owner]

  filter {
    name   = "name"
    values = [var.mssql_ami_name]
  }
}

data "aws_key_pair" "mssql" {
  key_name = var.mssql_key_pair_name
}

data "template_file" "init" {
  template = file("${path.module}/bootstrap.win.txt")

  vars = {
    admin_password = var.windows_admin_password
  }
}

data "aws_iam_instance_profile" "ec2-resources-iam-profile" {
  name = "EC2DomainJoin${local.env_title}"
}

resource "aws_instance" "mssql" {
  ami                         = data.aws_ami.mssql.image_id
  key_name                    = data.aws_key_pair.mssql.key_name
  iam_instance_profile        = data.aws_iam_instance_profile.ec2-resources-iam-profile.name
  instance_type               = var.mssql_instance_type
  subnet_id                   = slice(var.database_subnets, 0, 1)[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.aws_security_group_mssql_id]
  user_data                   = data.template_file.init.rendered
  get_password_data           = true
  tags                        = local.tags
}

resource "aws_ssm_document" "ssm_document" {
  name          = "ssm_document_${var.ad_name}"
  document_type = "Command"
  content       = <<DOC
{
    "schemaVersion": "1.0",
    "description": "Automatic Domain Join Configuration",
    "runtimeConfig": {
        "aws:domainJoin": {
            "properties": {
                "directoryId": "${var.ad_id}",
                "directoryName": "${var.ad_name}",
                "dnsIpAddresses": ${jsonencode(var.ad_dns_ip_addresses)}
            }
        }
    }
}
DOC

}

resource "aws_ssm_association" "associate_ssm" {
  name        = aws_ssm_document.ssm_document.name
  instance_id = aws_instance.mssql.id
}
