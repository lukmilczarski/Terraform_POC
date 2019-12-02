# Internet VPC
#resource "aws_vpc" "main" {
#  cidr_block           = "10.0.0.0/16"
#  instance_tenancy     = "default"
#  enable_dns_support   = "true"
#  enable_dns_hostnames = "true"
#  enable_classiclink   = "false"
#  tags = {
#    Name = "main"
#  }
#}

# Subnets
resource "aws_subnet" "main-public" {
#  vpc_id                  = aws_vpc.main.id
  vpc_id                  = "vpc-0a657c4ad2e27235d"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-central-1b"

  tags = {
    Name = "main-public"
  }
}

resource "aws_subnet" "main-private" {
#  vpc_id                  = aws_vpc.main.id
  vpc_id                  = "vpc-0a657c4ad2e27235d"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-central-1b"

  tags = {
    Name = "main-private"
  }
}


# Internet GW
#resource "aws_internet_gateway" "main-gw" {
#  vpc_id = aws_vpc.main.id
#
#  tags = {
#    Name = "main"
#  }
#}

# route tables
resource "aws_route_table" "main-public" {
  vpc_id = "vpc-0a657c4ad2e27235d"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-03a9174fb1381c408"
  }

  tags = {
    Name = "main-public"
  }
}


# route associations public
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.main-public.id
  route_table_id = aws_route_table.main-public.id
}

#########################################

# nat gw
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main-public.id
#  depends_on    = "igw-03a9174fb1381c408"
}

# VPC setup for NAT
resource "aws_route_table" "main-private" {
  vpc_id = "vpc-0a657c4ad2e27235d"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "main-private"
  }
}

# route associations private
resource "aws_route_table_association" "main-private" {
  subnet_id      = aws_subnet.main-private.id
  route_table_id = aws_route_table.main-private.id
}

