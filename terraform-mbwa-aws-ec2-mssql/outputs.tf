output "mssql_ami_id" {
  value = data.aws_ami.mssql.id
}

output "key_pair_name" {
  value = data.aws_key_pair.mssql.key_name
}

output "key_pair_id" {
  value = data.aws_key_pair.mssql.id
}

output "server_id1" {
  value = aws_instance.mssql.id
}
