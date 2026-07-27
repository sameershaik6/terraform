# OpenTofu and Terraform Migration Guide

This document gives a simple overview of OpenTofu, how to migrate from Terraform to OpenTofu, and what changes or stays the same.

## What is OpenTofu?

OpenTofu is an open-source Infrastructure as Code tool that works in a very similar way to Terraform. It uses the same HCL language, providers, modules, and state files in many cases.

## Why migrate?

Many teams move to OpenTofu to:
- use a fully open-source IaC workflow
- avoid vendor lock-in
- keep working with existing Terraform-style code
- maintain compatibility with familiar commands and structures

## Migration steps

1. Backup your current state
   - Keep a copy of your Terraform state files.
   - If you use remote backends, make sure you know the backend configuration.

2. Install OpenTofu
   - Download and install OpenTofu on your machine.
   - Verify it with:
     ```bash
     tofu --version
     ```

3. Keep your existing code
   - Most `.tf` files can be reused as-is.
   - Keep providers and modules versions pinned.

4. Initialize the working directory
   ```bash
   tofu init
   ```

5. Review the plan carefully
   ```bash
   tofu plan
   ```

6. Apply changes only after review
   ```bash
   tofu apply
   ```

7. Test in a safe environment first
   - Start with dev/test before production.
   - Compare the plan output carefully.

## Safety tips

- Always run `tofu plan` before `tofu apply`.
- Use version control for your infrastructure code.
- Keep state backups and state locking enabled.
- Test changes in lower environments first.
- Avoid changing provider versions and backend settings at the same time.
- Review module updates and variable changes carefully.

## What changes from Terraform to OpenTofu?

### Things that change
- CLI command name changes from `terraform` to `tofu`.
- Example:
  - `terraform init` → `tofu init`
  - `terraform plan` → `tofu plan`
  - `terraform apply` → `tofu apply`
  - `terraform destroy` → `tofu destroy`
- The branding and ecosystem around the tool are different.

### Things that stay the same
- HCL syntax remains the same.
- `.tf` files remain the same.
- Providers and modules are still used the same way.
- State management and backend concepts are still the same.
- The basic workflow remains:
  1. init
  2. plan
  3. apply
  4. destroy

## Simple comparison

| Topic | Terraform | OpenTofu |
|------|-----------|----------|
| Main language | HCL | HCL |
| File format | `.tf` | `.tf` |
| Providers | Yes | Yes |
| Modules | Yes | Yes |
| State files | Yes | Yes |
| CLI command | `terraform` | `tofu` |

## Recommended migration approach

- Use OpenTofu for new projects or non-critical environments first.
- Migrate existing Terraform code gradually.
- Keep changes small and review outputs carefully.
- Treat this as a controlled migration, not a big-bang change.

## Final note

OpenTofu is very close to Terraform in daily use. If you already know Terraform, the learning curve is small. The main change is mostly the tool name and workflow, while the core infrastructure concepts remain familiar.
