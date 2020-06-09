output "name_servers" {
  value = aws_route53_zone.main.name_servers
  description = "List of name servers that belong to the Hosted DNS Zone"
}
