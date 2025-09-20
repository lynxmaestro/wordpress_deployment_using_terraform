resource "aws_security_group" "frontend" {
  name        = "${var.project_name}-${var.project_env}-frontend"
  description = "${var.project_name}-${var.project_env}-frontend"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-${var.project_env}-frontend"
    project = var.project_name
    env     = var.project_env
  }
}

resource "aws_vpc_security_group_ingress_rule" "frontend_http" {
  security_group_id = aws_security_group.frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "frontend_https" {
  security_group_id = aws_security_group.frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "frontend_ssh" {
  security_group_id            = aws_security_group.frontend.id
  referenced_security_group_id = aws_security_group.bastion.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

resource "aws_vpc_security_group_egress_rule" "frnt_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "frnt_allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.frontend.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-${var.project_env}-bastion"
  description = "${var.project_name}-${var.project_env}-bastion"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-${var.project_env}-bastion"
    project = var.project_name
    env     = var.project_env
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "bas_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_security_group" "backend" {
  name        = "${var.project_name}-${var.project_env}-backend"
  description = "${var.project_name}-${var.project_env}-backend"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-${var.project_env}-backend"
    project = var.project_name
    env     = var.project_env
  }
}

resource "aws_vpc_security_group_ingress_rule" "backend" {
  security_group_id            = aws_security_group.backend.id
  referenced_security_group_id = aws_security_group.frontend.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}

resource "aws_vpc_security_group_egress_rule" "bac_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.backend.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_ingress_rule" "backend_ssh" {
  security_group_id            = aws_security_group.backend.id
  referenced_security_group_id = aws_security_group.bastion.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}
