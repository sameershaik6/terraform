resource "aws_vpc" "vpc1" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.tag_vpc
  }

}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.subnet_cidr_block
  tags = {
    Name = var.tag_subnet
  }
}