#creation of custom network configuration using terraform

#creation of vpc
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "custom-vpc"
  }
  
}

#craetion of public subnet
resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "custom-subnet"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"
  tags = {
    Name = "custom-subnet-2"
  }
}

#creation of private subnet
resource "aws_subnet" "subnet2-private" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "custom-private-subnet2"
  }
}

#creation of internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "custom-igw"
  }
}

#creation of route table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "custom-route-table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#association of route table with public subnet
resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

#creation of elastic ip for nat gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"    
}

#creation of nat gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet.id
  tags = {
    Name = "custom-nat-gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}

#creation of private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "custom-private-route-table"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

#association of private route table with private subnet
resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.subnet2-private.id
  route_table_id = aws_route_table.private_route_table.id
}

#creation of security group
resource "aws_security_group" "security_group" {
  name        = "custom-security-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}



#creation of public ec2 instance
resource "aws_instance" "ec2_instance" {
  ami           = "ami-01edba92f9036f76e" # Amazon Linux 2 AMI
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "custom-ec2-instance"
  }
}

#creation of private ec2 instance
resource "aws_instance" "private-instance" {
    ami           = "ami-01edba92f9036f76e" # Amazon Linux 2 AMI
    instance_type = "t3.micro"
    subnet_id     = aws_subnet.subnet2-private.id
    vpc_security_group_ids = [aws_security_group.security_group.id]
    associate_public_ip_address = false
    
    tags = {
        Name = "custom-private-ec2-instance"
    }
  
}