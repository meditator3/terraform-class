resource "aws_instance" "ariel-terraform-demo-8" {
    ami   = "ami-0e5f882be1900e43b"
    instance_type = "t2.small"
}