data "aws_route53_zone" "selected" {
  name         = "jeethu.shop"
  private_zone = false
}

data "aws_availability_zones" "available" {
  state = "available"
}

