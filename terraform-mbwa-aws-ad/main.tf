variable "aws_region" {
  type    = string
  default = ""
}

variable "environment_name" {
  type    = string
  default = ""
}

variable "ad_name" {
  type    = string
  default = ""
}

variable "ad_password" {
  type      = string
  default   = ""
  sensitive = true
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
    ops_module_repo_path = "terraform-mbwa-aws-ad",
    ops_owners           = "kcoconnor",
  }
}

data "aws_vpc" "vpc" {
  tags = {
    Name = var.environment_name
  }
}


data "aws_subnet_ids" "database" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    subnet_tier = "database"
  }
}

resource "aws_directory_service_directory" "ad" {
  name     = var.ad_name
  password = var.ad_password
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id = data.aws_vpc.vpc.id
    # Only 2 subnets, must be in different AZs
    subnet_ids = slice(tolist(data.aws_subnet_ids.database.ids), 0, 2)
  }

  tags = merge(local.tags, var.additional_tags, )

}

