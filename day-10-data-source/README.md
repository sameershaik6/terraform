Here is a simple `README.md` you can use for your Terraform Data Source project.

````md
# Terraform Data Sources

## What is a Data Source?

A **data source** in Terraform is used to **read existing infrastructure** from a cloud provider. It does not create or modify resources.

In this project, Terraform reads existing AWS resources and uses them to launch an EC2 instance.

---

## Why Use Data Sources?

Instead of hardcoding resource IDs like:

- AMI ID
- Subnet ID
- Security Group ID

Terraform automatically finds them.

This makes the code reusable and easier to maintain.

---

## Real-Time Use Case

In most companies:

- The **Network Team** creates VPCs, Subnets, and Security Groups.
- The **DevOps/Application Team** launches EC2 instances.

Instead of creating the networking resources again, the DevOps team uses **data sources** to read the existing resources.

Example:

```
Existing AWS Resources
│
├── VPC
├── Subnet
├── Security Group
└── Amazon Linux AMI
        │
        ▼
Terraform Data Sources
        │
        ▼
Launch EC2 Instance
```

---

## Data Sources Used

### 1. AMI

Fetches the latest Amazon Linux 2023 AMI.

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
```

---

### 2. Subnet

Reads an existing subnet.

```hcl
data "aws_subnet" "sub" {
  filter {
    name   = "tag:Name"
    values = ["my-subnet"]
  }
}
```

---

### 3. Security Group

Reads an existing security group.

```hcl
data "aws_security_group" "sg" {
  filter {
    name   = "group-name"
    values = ["my-sg"]
  }
}
```

---

## Launch EC2 Using Data Sources

```hcl
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.sub.id
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  tags = {
    Name = "Terraform-EC2"
  }
}
```

---

## Benefits of Data Sources

- Reuse existing AWS resources.
- Avoid hardcoding IDs.
- Automatically use the latest AMI.
- Easy to maintain.
- Commonly used in real-world DevOps projects.

---

## Commands

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

---

## Project Workflow

```
AWS Existing Resources
        │
        ├── AMI
        ├── Subnet
        └── Security Group
              │
              ▼
      Terraform Data Sources
              │
              ▼
        Launch EC2 Instance
```
````

This README is simple, beginner-friendly, and reflects a real-world Terraform workflow.
