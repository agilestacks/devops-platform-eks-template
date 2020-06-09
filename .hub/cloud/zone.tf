resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    "Provider" : "Agile Stacks Inc"
    "Purpose"  : "Hosted zone for Kubernetes cluster"
    "superhub.io/stack/${var.domain_name}" : "owned"
  }
}