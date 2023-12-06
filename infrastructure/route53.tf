resource "aws_route53_zone" "dns_zone" {
  name = var.dns_zone
}

output "route53_nameservers" {
  value = aws_route53_zone.dns_zone.name_servers
}
