# internet VPC

#the second name-is its name in terraform(not aws)
resource "aws_vpc" "ariel-terraform-vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"   # that's NOT default vpc, it just doesn't run on dedicated hardware
    enable_dns_support = "true" # allows recognizable inner/private names
    enable_dns_hostnames = "true" #can translate name to ip
    #enable_classiclink = "false"
    tags = {
        Name = "main-ariel-terraF"
        ManagedBy = "terraform"
    }
}

# all subnets resources 

resource "aws_subnet" "main-public-1" {
    vpc_id = aws_vpc.ariel-terraform-vpc.id
    # this is the cidr of the SUBNET!\
    # public is 101...etc
    # and /24 because its smaller
    cidr_block = "10.0.101.0/24"
    map_public_ip_on_launch = "true"
    #availability zone should be hardcoded..
    availability_zone = "eu-west-2a"

}
resource "aws_subnet" "main-public-2" {
    vpc_id = aws_vpc.ariel-terraform-vpc.id
    # this is the cidr of the SUBNET!\
    # public is 101...etc
    # and /24 because its smaller
    cidr_block = "10.0.102.0/24"
    map_public_ip_on_launch = "true"
    #availability zone should be hardcoded..
    availability_zone = "eu-west-2b"

}
resource "aws_subnet" "main-public-3" {
    vpc_id = aws_vpc.ariel-terraform-vpc.id
    # this is the cidr of the SUBNET!\
    # public is 101...etc
    # and /24 because its smaller
    cidr_block = "10.0.103.0/24"
    map_public_ip_on_launch = "true"
    #availability zone should be hardcoded..
    availability_zone = "eu-west-2c"

}

resource "aws_subnet" "main-private-1" {
    vpc_id = aws_vpc.ariel-terraform-vpc.id
    # this is the cidr of the SUBNET!\
    # public is 101...etc
    # and /24 because its smaller
    cidr_block = "10.0.11.0/24"
    map_public_ip_on_launch = "false"
    #availability zone should be hardcoded..
    availability_zone = "eu-west-2a"

}
resource "aws_subnet" "main-private-2" {
    vpc_id = aws_vpc.ariel-terraform-vpc.id
    # this is the cidr of the SUBNET!\
    # public is 101...etc
    # and /24 because its smaller
    cidr_block = "10.0.12.0/24"
    map_public_ip_on_launch = "false"
    #availability zone should be hardcoded..
    availability_zone = "eu-west-2b"

}

resource "aws_subnet" "main-private-3" {
    vpc_id = aws_vpc.ariel-terraform-vpc.id
    # this is the cidr of the SUBNET!\
    # public is 101...etc
    # and /24 because its smaller
    cidr_block = "10.0.13.0/24"
    map_public_ip_on_launch = "false"
    #availability zone should be hardcoded..
    availability_zone = "eu-west-2c"

}


# internet Gateway
resource "aws_internet_gateway" "main-gw" {
    vpc_id = aws_vpc.ariel-terraform-vpc.id
    tags = {
        Name = "main"
        ManagedBy = "terraform"
    }
}

# Public Route Table

resource "aws_route_table" "main-public" {
    vpc_id = aws_vpc.ariel-terraform-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        # not through the gateway? through the id?
        gateway_id = aws_internet_gateway.main-gw.id
       
    }
    tags = {
            Name = "main-public-1"
            ManagedBy = "terraform"
        }
}

resource "aws_route_table_association" "main-public-1a" {
    subnet_id = aws_subnet.main-public-1.id
    route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "main-public-2a" {
    subnet_id = aws_subnet.main-public-2.id
    route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "main-public-2c" {
    subnet_id = aws_subnet.main-public-3.id
    route_table_id = aws_route_table.main-public.id
}
