# The entire section create a certiface, public zone, and validate the certificate using DNS method
# Create the certificate using a wildcard for all the domains created in hracompany.ga
resource "aws_acm_certificate" "hracompany" {
  domain_name       = "*.hracompany.ga"
  validation_method = "DNS"
}

resource "aws_route53_zone" "hracompany" {
  name = "hracompany.ga"
}
# calling the hosted zone
data "aws_route53_zone" "hracompany" {
  name         = "hracompany.ga"
  private_zone = false
}

# selecting validation method
resource "aws_route53_record" "hracompany" {
  for_each = {
    for dvo in aws_acm_certificate.hracompany.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.hracompany.zone_id
}
