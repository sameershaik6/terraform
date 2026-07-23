# Terraform workspaces are used to manage different environments
# with the same configuration files.
# Example: dev, test, and prod can all use the same code,
# but each workspace keeps its own state separately.

# Why do we use workspaces?
# - To avoid writing separate code for each environment
# - To keep state separate for each environment
# - To switch easily between environments with one configuration

# Common workspace commands:
# terraform workspace list        -> show all workspaces
# terraform workspace new dev     -> create a new workspace named dev
# terraform workspace select dev  -> switch to the dev workspace
# terraform plan                  -> preview changes for the current workspace
# terraform apply                 -> apply changes to the current workspace
# terraform destroy               -> destroy resources from the current workspace

# How it works:
# - Each workspace has its own state file.
# - So resources created in dev do not mix with resources in prod.
# - When you run plan/apply, Terraform uses the state of the currently selected workspace.

# When workspaces are useful:
# - Small or medium projects
# - When you want one codebase for multiple environments
# - When you want simple environment switching

# Disadvantages / caution:
# - Workspaces are simple, but they can become confusing in large projects
# - For bigger setups, many teams prefer separate directories or strong CI/CD rules

# Are workspaces used in real life?
# Yes, they are used in real projects, but not always for every team.
# In many real-world setups, people also use separate directories, modules,
# and different variable files for better control.

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
}