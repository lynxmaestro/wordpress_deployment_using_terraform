resource "aws_instance" "frontend" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  availability_zone           = data.aws_availability_zones.available.names[1]
  key_name                    = "cyber-mumbai"
  vpc_security_group_ids      = [aws_security_group.frontend.id]
  user_data                   = file("front_userdata.sh")
  user_data_replace_on_change = true
  subnet_id                   = aws_subnet.public1[1].id
  tags = {
    Name    = "${var.project_name}-${var.project_env}-frontend"
    project = var.project_name
    env     = var.project_env
  }
}


resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  availability_zone           = data.aws_availability_zones.available.names[0]
  key_name                    = "cyber-mumbai"
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  user_data_replace_on_change = true
  subnet_id                   = aws_subnet.public1[0].id
  tags = {
    Name    = "${var.project_name}-${var.project_env}-bastion"
    project = var.project_name
    env     = var.project_env
  }
}



resource "aws_instance" "backend" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  availability_zone           = data.aws_availability_zones.available.names[0]
  user_data                   = file("back_userdata.sh")
  key_name                    = "cyber-mumbai"
  vpc_security_group_ids      = [aws_security_group.backend.id]
  user_data_replace_on_change = true
  subnet_id                   = aws_subnet.private[0].id
  tags = {
    Name    = "${var.project_name}-${var.project_env}-backend"
    project = var.project_name
    env     = var.project_env
  }
}
