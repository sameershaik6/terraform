# Day 11 - Provisioners with triggers

This folder explains Terraform provisioners in a simple way.

## What is a provisioner?
A provisioner is a block used to run commands or copy files after a resource is created.
It is commonly used with an EC2 instance to install packages, create files, or run setup scripts.

## Provisioners in EC2 resources
You can place provisioners inside an EC2 resource block such as `aws_instance`.
This means the provisioner runs after the EC2 instance is created.

Example idea:
- copy a file to the instance
- run a shell command remotely
- run a local command from your machine

## Why use `null_resource`?
A `null_resource` is often used when you want to run provisioners separately from the main infrastructure resource.
It helps keep the provisioning logic clear and allows you to add `triggers` for reruns.

## Types of provisioners explained simply
### 1. `file` provisioner
Used to copy files from your local machine to the remote EC2 instance.

Example:
- copy a script or config file
- place it in `/home/ubuntu/`

### 2. `remote-exec` provisioner
Used to run commands on the remote EC2 instance over SSH.

Example:
- create a file
- install software
- run a setup command

### 3. `local-exec` provisioner
Used to run commands on your local machine.

Example:
- create a local file
- print a message
- run a shell command from your computer

## Important note about `null_resource`
`null_resource` is not a real cloud resource. It is used only to run provisioners and make them easier to control with `triggers`.
It is very useful when you want to run a task after the main resource is ready.

## Trigger examples in this folder
This folder demonstrates two ways to trigger provisioners:

1. Timestamp-based trigger
   - Uses `timestamp()` inside `triggers`
   - Forces the provisioner to run again on every apply
   - Good for learning and testing

2. Script hash-based trigger
   - Uses `filemd5()` inside `triggers`
   - Re-runs only when the script content changes
   - Good for real-world automation

## Files
- `main.tf` - AWS resources and the provisioner examples
- `setup.sh` - Script used by the hash-based provisioner
- `provider.tf` - AWS provider configuration

## Prerequisites
- Terraform installed
- AWS credentials configured
- SSH private key available at `C:/Users/samee/.ssh/id_ed25519`
- Public key available at `C:/Users/samee/.ssh/id_ed25519.pub`

## Run
```bash
terraform init
terraform plan
terraform apply
```

## Notes
- The EC2 instance is created first.
- The provisioner blocks run after the instance is ready.
- The timestamp-based example will re-run every time you apply changes.
- The script-hash example will re-run only when `setup.sh` changes.
