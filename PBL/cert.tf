# calling the hosted zone
data "aws_route53_zone" "hracompany" {
  name         = "hracompany.ga"
  private_zone = false
}