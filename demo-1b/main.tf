

# the name after the aws_instance is just its name on its_name_in_terraForm

resource "aws_instance" "its_name_in_terraForm" {
    count = 1
    ami = "${var.AMIS[var.region]}"
    instance_type = "t2.micro"
}


