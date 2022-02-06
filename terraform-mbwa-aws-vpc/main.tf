variable "aws_region" {
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

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "database_subnets" {
  description = "A list of database subnets"
  type        = list(string)
  default     = []
}

locals {
  public_subnet_tags     = { subnet_tier = "public", }
  private_subnet_tags    = { subnet_tier = "private", }
  database_subnet_tags   = { subnet_tier = "database", }
  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false
  #create_database_subnet_group should be false
  #it is created by the vpc module
  #if true, the resource will be created again
  #resulting in an error
  create_database_subnet_group           = false
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    ops_env              = "${var.environment_name}"
    ops_managed_by       = "terraform",
    ops_module_repo      = "kcoconnor/terraform-mbwa-aws",
    ops_module_repo_path = "terraform-mbwa-aws-vpc",
    ops_owners           = "kcoconnor",
  }
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                                   = var.environment_name
  cidr                                   = var.vpc_cidr
  azs                                    = var.azs
  public_subnets                         = var.public_subnets
  public_subnet_tags                     = local.public_subnet_tags
  private_subnets                        = var.private_subnets
  private_subnet_tags                    = local.private_subnet_tags
  database_subnets                       = var.database_subnets
  database_subnet_tags                   = local.database_subnet_tags
  enable_nat_gateway                     = local.enable_nat_gateway
  single_nat_gateway                     = local.single_nat_gateway
  one_nat_gateway_per_az                 = local.one_nat_gateway_per_az
  enable_vpn_gateway                     = local.enable_vpn_gateway
  create_database_subnet_group           = local.create_database_subnet_group
  create_database_subnet_route_table     = local.create_database_subnet_route_table
  create_database_internet_gateway_route = local.create_database_internet_gateway_route
  enable_dns_hostnames                   = local.enable_dns_hostnames
  enable_dns_support                     = local.enable_dns_support
  tags                                   = merge(local.tags, var.additional_tags, )

}
