resource "aws_instance" "name" {
    ami           = "ami-0b826bb6d96d2afe4"
    instance_type = "t3.micro"

    # count tells Terraform how many copies of this resource to create.
    # If var.ec2 has 3 values, Terraform creates 3 EC2 instances.
    # Each instance gets its own index: 0, 1, 2, and so on.
    count = length(var.ec2)

    tags = {
        # count.index is the current position of this instance in the list.
        # Example: first instance uses index 0, second uses index 1.
        Name = var.ec2[count.index]
    }
}

# How count works:
# - Terraform creates resources in order from index 0 upward.
# - If you remove one item from the list, Terraform may destroy the last instance
#   or replace resources based on the index changes.
# - This is why count is not ideal when the list order is likely to change often.

# Disadvantages of count:
# - If you delete one middle item, Terraform may cause replacement or destruction
#   of resources because indexes shift.
# - It is less flexible than for_each when you want stable resource identities.
# - It is harder to manage when instances are added/removed dynamically.

# When count is best used:
# - When you want a simple fixed number of identical resources.
# - Example: create 3 web servers, 2 jump boxes, or 1 bastion host.
# - When the number is known in advance and order does not matter much.


