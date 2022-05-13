# The entire section create a certiface, public zone, and validate the certificate using DNS method
# Create the certificate using a wildcard for all the domains created in hracompany.ga
resource "aws_acm_certificate" "hracompany" {
  domain_name       = "*.hracompany.ga"
  validation_method = "DNS"
}

resource "aws_route53_zone" "hracompany" {
  name = "example.com"
}
# calling the hosted zone
data "aws_route53_zone" "hracompany" {
  name         = "hracompany.ga"
  private_zone = false
}