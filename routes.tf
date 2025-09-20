resource "aws_route53_zone" "private" {
  name = var.private_zone_name

  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "frontend"
  type    = "A"
  ttl     = 300
  records = [aws_instance.frontend.private_ip]
}


resource "aws_route53_record" "backend" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "backend"
  type    = "A"
  ttl     = 300
  records = [aws_instance.backend.private_ip]
}


resource "aws_route53_record" "bast" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "bastion"
  type    = "A"
  ttl     = 300
  records = [aws_instance.bastion.private_ip]
}


resource "aws_route53_record" "pub_z" {
  zone_id = data.aws_route53_zone.selected.id
  name    = "blog"
  type    = "A"
  ttl     = 300
  records = [aws_instance.frontend.public_ip]
}
