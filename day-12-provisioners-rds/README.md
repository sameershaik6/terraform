# Day 12 - Provisioners for RDS SQL Script Execution

This folder shows two simple ways to run an SQL script against an AWS RDS MySQL database using Terraform provisioners.

## What is this example about?
Terraform provisioners are used to perform actions after a resource is created.
In this folder, we use them to run SQL scripts against RDS.

## 1. Local execution
Folder: `local-execution`

This example runs the SQL script from your local machine.

### How it works
- Terraform creates the RDS instance.
- A `null_resource` is created.
- The `local-exec` provisioner runs a command like this:

```bash
mysql -h <rds-endpoint> -u admin -pPassword123! dev < init.sql
```

### Best use case
- useful for learning and simple testing
- good when you want to run the SQL script directly from your machine

### Important note
This method runs from the machine where Terraform is executed.

---

## 2. Remote execution
Folder: `remote-execution`

This example runs the SQL script from an EC2 instance.

### How it works
- Terraform creates an EC2 instance.
- A `null_resource` is created.
- The `file` provisioner copies the SQL file to the EC2 instance.
- The `remote-exec` provisioner runs commands on the EC2 instance.
- The EC2 instance connects to RDS and runs the SQL script.

### Best use case
- useful when you want the database setup to happen from a server
- good for automation and more realistic deployment flow

### Important note
This method uses SSH to reach the EC2 instance and then runs the SQL commands remotely.

---

## Difference between local and remote execution

| Type | Where the script runs | Good for |
|---|---|---|
| Local execution | Your laptop / local machine | Learning, testing, small tasks |
| Remote execution | EC2 instance | Automation, server-based setup |

---

## Files in this folder
- `local-execution/main.tf` - creates RDS and runs SQL locally
- `remote-execution/main.tf` - creates EC2 and runs SQL remotely
- `local-execution/init.sql` - SQL file used by the local example
- `remote-execution/init.sql` - SQL file used by the remote example

---

## How to run
### Local execution
```bash
cd local-execution
terraform init
terraform apply
```

### Remote execution
```bash
cd remote-execution
terraform init
terraform apply
```

---

## Simple explanation
- `local-exec` = run from your computer
- `remote-exec` = run from another machine like EC2
- `file` = copy files to that remote machine
- `null_resource` = help you run these actions after the main resource is ready

---

## Notes
- These examples are for learning and practice.
- In real projects, secrets like passwords should be stored safely using variables or secret managers.
- The `triggers` block is used here to force the provisioner to run again on every apply.
