resource "aws_vpc" "vpc" {
  cidr_block              = var.cidr_block
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "${var.project_name}-igw"
  }
}

data "aws_availability_zones" "available_zones" {
    state = "available"

    filter {
    name   = "region-name"
    values = ["ap-south-1"]
  }

  filter {
    name   = "zone-name"
    values = ["ap-south-1a", "ap-south-1b"]
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(data.aws_availability_zones.available_zones.names)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets,count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "${var.project_name}-public-subnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "${var.project_name}-Public route Table"
  }
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  count               = length(var.public_subnets)
  subnet_id           = element(aws_subnet.public_subnet.*.id,count.index)
  route_table_id      = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_subnet" {
  count                    = length(data.aws_availability_zones.available_zones.names)
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = element(var.private_subnets,count.index)
  availability_zone        = data.aws_availability_zones.available_zones.names[count.index]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "${var.project_name}-private_subnet"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id       = aws_vpc.vpc.id

  tags       = {
    Name     = "${var.project_name}-Private route Table"
  }
}

resource "aws_route_table_association" "private_subnet_route_table_association" {
  count               = length(var.private_subnets)
  subnet_id           = element(aws_subnet.private_subnet.*.id,count.index)
  route_table_id      = aws_route_table.private_route_table.id
}

resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.internet_gateway]

   tags       = {
    Name     = "${var.project_name}-EIP"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)

  tags       = {
    Name     = "${var.project_name}-NAT"
  }
}

resource "aws_route" "private_internet_gateway" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat.id
}