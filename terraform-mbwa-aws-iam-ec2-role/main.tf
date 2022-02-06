variable "environment_name" {
  type    = string
  default = ""
}

locals {

  env_title = title("${var.environment_name}")

  tags = {
    ops_env              = "${var.environment_name}"
    ops_managed_by       = "terraform",
    ops_module_repo      = "kcoconnor/terraform-mbwa-aws",
    ops_module_repo_path = "terraform-mbwa-aws-iam-ec2-role",
    ops_owners           = "kcoconnor",
  }
}

resource "aws_iam_role" "ec2-resources-iam-role" {
  name               = "EC2Role${local.env_title}"
  description        = "Allows EC2 instances to call AWS services"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": {
"Effect": "Allow",
"Principal": {"Service": "ec2.amazonaws.com"},
"Action": "sts:AssumeRole"
}
}
EOF

  tags = local.tags

}

resource "aws_iam_instance_profile" "ec2-resources-iam-profile" {
  name = "EC2DomainJoin${local.env_title}"
  role = aws_iam_role.ec2-resources-iam-role.name
}

resource "aws_iam_role_policy_attachment" "ec2-resources-ssm-policy" {
  role       = aws_iam_role.ec2-resources-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2-resources-directory-policy" {
  role       = aws_iam_role.ec2-resources-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}

resource "aws_iam_role_policy_attachment" "ec2-resources-cloud-watch-policy" {
  role       = aws_iam_role.ec2-resources-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

