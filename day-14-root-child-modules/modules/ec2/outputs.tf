output "instance_id" {
  value       = aws_instance.this.id
  description = "ID of the launched EC2 instance."
}

output "instance_public_ip" {
  value       = aws_instance.this.public_ip
  description = "Public IP address of the EC2 instance."
}
