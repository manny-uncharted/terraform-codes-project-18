# The entire section create a certiface, public zone, and validate the certificate using DNS method

# Create the certificate using a wildcard for all the domains created in teskers.online
resource "aws_acm_certificate" "teskers" {
  domain_name       = "*.teskers.online"
  validation_method = "DNS"
}

# calling the hosted zone
data "aws_route53_zone" "teskers" {
  name         = "teskers.online"
  private_zone = false
}

# selecting validation method
resource "aws_route53_record" "teskers" {
  for_each = {
    for dvo in aws_acm_certificate.teskers.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.teskers.zone_id
}

# validate the certificate through DNS method
resource "aws_acm_certificate_validation" "teskers" {
  certificate_arn         = aws_acm_certificate.teskers.arn
  validation_record_fqdns = [for record in aws_route53_record.teskers : record.fqdn]
}

# create records for tooling
resource "aws_route53_record" "tooling" {
  zone_id = data.aws_route53_zone.teskers.zone_id
  name    = "tooling.teskers.online"
  type    = "A"

  alias {
    name                   = aws_lb.ext-alb.dns_name
    zone_id                = aws_lb.ext-alb.zone_id
    evaluate_target_health = true
  }
}

# create records for wordpress
resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.teskers.zone_id
  name    = "wordpress.teskers.online"
  type    = "A"

  alias {
    name                   = aws_lb.ext-alb.dns_name
    zone_id                = aws_lb.ext-alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "ionos_domain_redirect" {
  zone_id = data.aws_route53_zone.teskers.zone_id
  name = "_domainconnect.teskers.online"
  type = "CNAME"
  ttl = "3600"
  records = ["_domainconnect.ionos.com.teskers.online"]
}