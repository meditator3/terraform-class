/*
check if there's a default VPC, if there's one use it- 
and fetch me the subnets of that vpc.

*/

resource "aws_default_vpc" "default" {
    tags = {
        Name = "default VPC"
    }
}
# from the main it takes the subnets from here, it 
# creates 3 machines(according to the default specifically)
# for each AZ(Azone)
resource "aws_default_subnet" "default_az1" {
    availability_zone = "${var.AWS_REGION}a"

    tags  = {
        ManagedBy = "terraform"
        Name      = "default Subnet for ${var.AWS_REGION}a"
    }
}
resource "aws_default_subnet" "default_az2" {
    availability_zone = "${var.AWS_REGION}b"

    tags  = {
        ManagedBy = "terraform"
        Name      = "default Subnet for ${var.AWS_REGION}b"
    }
}

resource "aws_default_subnet" "default_az3" {
    availability_zone = "${var.AWS_REGION}c"

    tags  = {
        ManagedBy = "terraform"
        Name      = "default Subnet for ${var.AWS_REGION}c"
    }
}