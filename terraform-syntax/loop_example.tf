variable "instances" {
    type = map(object({
        ami = string
        instance_type = string
    }))
    default = {
        example-instance-1 = {
        ami = "ami-fdsf4gfdgfd5646"
        instance_type = t2.micro
        }
   
        example-instance-2 = {
            ami = "ami-fdsf4gfd43d5646"
            instance_type = t2.xlarge
        }
   }
}

resource "aws_instance" "example" {
    for_each = var.instances
    ami = each.value.ami
    instance_type = each.value.instance_type
}