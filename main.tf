resource "aws_vpc" "main" {
  cidr_block           = var.main_network
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.project_name}-${var.project_env}-vpc"
    project = var.project_name
    env     = var.project_env
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-${var.project_env}-igw"
    project = var.project_name
    env     = var.project_env
  }
}

resource "aws_subnet" "public1" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.main_network, 3, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project_name}-${var.project_env}-public-${count.index + 1}"
    project = var.project_name
    env     = var.project_env
  }
}

resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.main_network, 3, "${count.index + 3}")
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name    = "${var.project_name}-${var.project_env}-private-${count.index + 1}"
    project = var.project_name
    env     = var.project_env
  }
}

resource "aws_nat_gateway" "nat" {
  count         = var.enable_nat_gw == true ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public1[1].id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat" {
  count  = var.enable_nat_gw == true ? 1 : 0
  domain = "vpc"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = var.main_network
    gateway_id = "local"
  }
  tags = {
    Name    = "${var.project_name}-${var.project_env}-publicRT"
    project = var.project_name
    env     = var.project_env
  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.main_network
    gateway_id = "local"
  }

  tags = {
    Name    = "${var.project_name}-${var.project_env}-privateRT"
    project = var.project_name
    env     = var.project_env
  }
}

resource "aws_route" "priv" {
  route_table_id         = aws_route_table.private.id
  count                  = var.enable_nat_gw == true ? 1 : 0
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}

resource "aws_route_table_association" "pub" {
  count          = 3
  subnet_id      = aws_subnet.public1[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
