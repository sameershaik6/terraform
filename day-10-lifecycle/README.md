# Terraform Lifecycle Meta-Argument

The `lifecycle` block controls how Terraform creates, updates, and destroys resources. It helps you avoid downtime, protect important resources, or ignore specific changes.

## 1. `create_before_destroy`

Creates the new resource first and deletes the old one afterward.

```hcl
resource "aws_instance" "example" {
  # ...

  lifecycle {
    create_before_destroy = true
  }
}
```

**Use case:** Replace a resource without downtime.

---

## 2. `prevent_destroy`

Prevents Terraform from accidentally deleting a resource.

```hcl
resource "aws_instance" "example" {
  # ...

  lifecycle {
    prevent_destroy = true
  }
}
```

**Use case:** Protect production databases, EC2 instances, or other critical resources.

---

## 3. `ignore_changes`

Tells Terraform to ignore changes to specific attributes after the resource is created.

```hcl
resource "aws_instance" "example" {
  # ...

  lifecycle {
    ignore_changes = [tags]
  }
}
```

**Use case:** Ignore tags or attributes that are updated manually or by another tool without Terraform trying to change them back.