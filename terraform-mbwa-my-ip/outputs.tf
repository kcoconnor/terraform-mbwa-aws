output "myip" {
  description = "my ip"
  value       = "${chomp(data.http.myip.body)}/32"
}
