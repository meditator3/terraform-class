# to make it most costumizable, the following variables are all costumizable-
    # 1)CIDR blocks for main public/private, and for each AZ also
    # 2)Availability zones count and assigning accordingly via count.index
    # 3)Tags
    # 4)Elastic Ip, incase there is one defined by the user??


module "vpc"  {
    source = "./module_vpc"
    vpc_region = var.AWS_REGION
    
}