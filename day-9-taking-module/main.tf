module "instance" {
    source = "../day-9-modules"
    ami_id = "ami-01edba92f9036f76e"
    instance_ty = "t3.micro"
    instance_name = "my-instance"
}
