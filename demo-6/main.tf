module "module-ec2" {
    source = "./module-ec2/"
    key_name = 
    key_path =
    region = var.AWS_REGION
    vpc_id = aws_default_vpc.default.id
    destination = 
}