resource "aws_instance" "name" {
    ami           = "ami-0b826bb6d96d2afe4"
    instance_type = "t3.micro"

    # for_each loops over a collection of values.
    # Here, it uses the list from var.tags and turns it into a set.
    # Terraform creates one EC2 instance for each unique item in that set.
    for_each = toset(var.tags)

    tags = {
        # each.key is the current item being processed.
        # So each instance gets its own name from the list value.
        Name = each.key
    }
}
#examle with subnet association with for each
locals {
  subnet_ids = [
    aws_subnet.subnet1.id,
    aws_subnet.subnet2.id,
    aws_subnet.subnet3.id
  ]
}

resource "aws_route_table_association" "private" {
  for_each = toset(local.subnet_ids)

  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}

# How for_each works:
# - It iterates over each element in the collection.
# - Each item gets its own unique identity based on the key.
# - If you remove one item, Terraform removes only that one resource.
# - This is more stable than count because it does not rely on index numbers.

# Where for_each is best used:
# - When you have a list of similar resources and each one should have a stable name.
# - Example: multiple EC2 instances, IAM users, security groups, or S3 buckets.
# - When you want to add or remove items without affecting the others.
