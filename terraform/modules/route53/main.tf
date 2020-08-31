resource "aws_route53_record" "service" {
  zone_id = var.zone_id
  name    = "${var.subdomain}.coacerucc.work"
  type    = "A"

  alias {
    name                   = var.dns_name
    zone_id                = var.hosted_zone_id
    evaluate_target_health = true
  }
}
