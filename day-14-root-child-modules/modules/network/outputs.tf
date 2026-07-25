output "vpc_id" {
  value       = aws_vpc.this.id
  description = "The ID of the created VPC."
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "IDs of the public subnets created by the network module."
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "IDs of the private subnets created by the network module."
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.this.id
  description = "The ID of the created Internet Gateway."
}
