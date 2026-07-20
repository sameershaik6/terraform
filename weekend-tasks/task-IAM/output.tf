output "access_key" {
value = aws_iam_access_key.cli.id
}

output "secreta_key" {
  value = aws_iam_access_key.cli.secret
  sensitive = true
  #terraform output -raw secrete_key - to view sensitive values
}

output "password"{
    value = aws_iam_user_login_profile.name.password
    sensitive = true
    #terraform output -raw password - to view sensitive values
}

output "role_arn" {
  value = aws_iam_role.ec2_full_access.arn
  
}