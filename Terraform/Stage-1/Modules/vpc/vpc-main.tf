# Create the VPC
resource "aws_vpc" "Sprints_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Sprints_vpc"
  }
}

# Create the Public Subnet
resource "aws_subnet" "publica" {
  vpc_id                  = aws_vpc.Sprints_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

# Create the Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.Sprints_vpc.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = "eu-central-1c"
  tags = {
    Name = "private_subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "S_GW" {
  vpc_id = aws_vpc.Sprints_vpc.id
  tags = {
    Name = "Sprints_igw"
  }
}

# Create a Route Table for Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.Sprints_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.S_GW.id
  }

  tags = {
    Name = "Traffic-Route"
  }
}

# Associate the Public Route Table with the Public Subnet
resource "aws_route_table_association" "Traffic-Route" {
  subnet_id      = aws_subnet.publica.id
  route_table_id = aws_route_table.public_route_table.id
}

