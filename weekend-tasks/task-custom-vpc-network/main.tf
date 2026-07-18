# Create a VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "custom-my-vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "custom-public-subnet"
  }
}

# Create a private subnet
resource "aws_subnet" "private_subnet" {
    vpc_id                  = aws_vpc.custom_vpc.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "us-east-1a"
    tags = {
      Name = "custom-private-subnet"
    }
}

# Create an internet gateway
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id
    tags = {
        Name = "custom-igw"
    }
}

# Create a route table
resource "aws_route_table" "custom_route_table" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "custom-route-table"
  }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.custom_igw.id
    }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.custom_route_table.id
}

#create nat gateway
resource "aws_eip" "nat_eip" {
    domain = "vpc"
}

# Create a regional NAT gateway
resource "aws_nat_gateway" "custom_nat_gateway" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public_subnet.id
    tags = {
        Name = "custom-nat-gateway"
    }
}

# Create a route table for the private subnet
resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.custom_vpc.id
    tags = {
        Name = "custom-private-route-table"
    }
    route {
        cidr_block     = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.custom_nat_gateway.id
    }
}

# Associate the private route table with the private subnet
resource "aws_route_table_association" "private_subnet_association" {
    subnet_id      = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_route_table.id
}