output "ad_id" {
  description = "The ID of the AD"
  value       = resource.aws_directory_service_directory.ad.id
}

output "ad_name" {
  description = "The name of the AD"
  value       = var.ad_name
}

output "ad_access_url" {
  description = "The access url of the AD"
  value       = resource.aws_directory_service_directory.ad.access_url
}

output "ad_dns_ip_addresses" {
  description = "The dns ip addresses of the AD"
  value       = resource.aws_directory_service_directory.ad.dns_ip_addresses
}

output "ad_security_group_id" {
  description = "The IDsecurity_group_id of the AD"
  value       = resource.aws_directory_service_directory.ad.security_group_id
}
