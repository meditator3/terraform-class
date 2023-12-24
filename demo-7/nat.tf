# create NAT gateway - 
# because if privates want to go to the internet they need 
# the gateway (NAT kind)

resource "aws_eip" "nat" {
    domain = "vpc" 
} 

resource "aws_nat_gateway" "nat-gw" {
    #aws_eip = elastic ip
    allocation_id = aws_eip.nat.id
    
    subnet_id = aws_subnet.main-public-1.id
    # first! the nat gateway before 
    # internet gateway<
    # should be created inside the
    depends_on = [ aws_internet_gateway.main-gw]
}

# VPC setup for NAT...
# them route tables

resource "aws_route_table" "main-private"{
    vpc_id = aws_vpc.ariel-terraform-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-gw.id
    }

    tags = {
        Name = "main-private-1"
        ManagedBy = "TerraForm"
    }
}

resource "aws_route_table_association" "main-private-1a" {
    subnet_id = aws_subnet.main-private-1.id
    route_table_id = aws_route_table.main-private.id
}

resource "aws_route_table_association" "main-private-2a" {
    subnet_id = aws_subnet.main-private-2.id
    route_table_id = aws_route_table.main-private.id
}

resource "aws_route_table_association" "main-private-2c" {
    subnet_id = aws_subnet.main-private-3.id
    route_table_id = aws_route_table.main-private.id
}


