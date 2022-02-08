output "my_ip" {
  value = "${chomp(data.http.myip.body)}/32"
}
