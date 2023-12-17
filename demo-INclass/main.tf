

# the name after the aws_instance is just its name on its_name_in_terraForm

resource "aws_instance" "its_name_in_terraForm" {
    count = 5
    ami = "ami-0e5f882be1900e43b"
    instance_type = "t2.micro"
}


