resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev"
  }
}
#creation of subnet with custom network configuration
resource "aws_subnet" "dev_subnet" {
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "dev-subnet"
  }
}


#terraform target command is used to apply the changes to specific resources in the configuration. It allows you to selectively apply changes to a subset of resources, rather than applying changes to all resources in the configuration. This can be useful when you want to make changes to a specific resource without affecting other resources in the configuration.

#ex: tf plan --target=aws_vpc.dev_vpc
#tf apply --target=aws_vpc.dev_vpc --target=aws_subnet.dev_subnet #if multiple resosurce are to be applied then use --target for each resource