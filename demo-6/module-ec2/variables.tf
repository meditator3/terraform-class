variable "platform" {
    default = "ubuntu"
    description = "The OS platform"
}
variable "user" {
    default = {
        ubuntu = "ubuntu"
        rhel6  = "ec2-user"
        centos7 = "centos"
        rhel7 = "ec2-user"
    }
}

variable "ami" {
    description = "AWS AMI ID"
    type = map(string)
    default = {
        us-east-1-ubuntu    = "ami-0c7217cdde317cfec"
        eu-west-1-ubuntu    = "ami-0905a3c97561e0b69"
        eu-central-1-ubuntu = "ami-0faab6bdbac9486fb"
        eu-west-2-ubuntu    = "ami-0e5f882be1900e43b"
    }
}

variable "service_conf" {
    default = {
        ubuntu  = "apache2.service"
        rhel6   = "httpd"
        centos7 = "httpd"
        rhel7   = "httpd"
    }
}
variable "key_name" {
    description = "SSH key name in your AWS account"

}

variable "key_path" {
    description = "Path to the private key"

}

variable "region" {
    default = "eu-west-2"

}

variable "servers" {
    default = 3
    description = "The Number of Server to be Lunched"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "tagName" {
    default = "ariel-app"
}

variable "subnets" {
    type = map
    description = "map of subnet to deploy your resources"
}

variable "vpc_id" {
    type = string
    description = "ID of the vpc to use"
}