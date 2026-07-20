````markdown
# Terraform Import

`terraform import` is used to bring **existing infrastructure** under Terraform management.

It **does not create** a new resource. Instead, it associates an existing resource with a resource block in your Terraform configuration.

---

## Step 1: Create a Resource Block

First, define the resource in your `.tf` file.

```hcl
resource "aws_instance" "example" {
  # Configuration will be updated after import
}
```

---

## Step 2: Import the Existing Resource

Run the import command:

```bash
terraform import aws_instance.example i-0d6a221e9ec465568
```

After the import:

- The existing EC2 instance is added to the **Terraform state**.
- Terraform now knows that it manages this resource.
- The resource is **not recreated**.

> **Note:** `terraform import` updates only the **state file**. It does **not** automatically generate the complete resource configuration.

---

## Step 3: Run `terraform plan`

```bash
terraform plan
```

Terraform compares:

```
Terraform Configuration (.tf)
            ↓
Terraform State (.tfstate)
            ↓
Actual AWS Infrastructure
```

If the configuration does not match the imported resource, Terraform will show planned changes.

---

## Why Does `terraform plan` Show Changes?

Terraform asks:

> **"Does the configuration describe the imported resource exactly?"**

- ✅ Yes → No changes
- ❌ No → Terraform plans updates to make the infrastructure match the configuration

---

## Final Goal

Update your `.tf` file so it matches the imported resource.

When the configuration and the state match, running:

```bash
terraform plan
```

shows:

```text
No changes. Your infrastructure matches the configuration.
```

This means the imported resource is now fully managed by Terraform.
````
