# create vpc
resource "aws_vpc" "vpc" {
  cidr_block              = var.cidr_block
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "${var.project_name}-igw"
  }
}

# use data source to get all avalablility zones in region
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

# create route table and add public route
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

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_route_table_association" {
  count               = length(var.public_subnets)
  subnet_id           = element(aws_subnet.public_subnet.*.id,count.index)
  route_table_id      = aws_route_table.public_route_table.id
}

# create private app subnet az1
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


