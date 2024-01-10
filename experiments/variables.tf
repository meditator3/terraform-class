variable "region" {
    description = "region"
    default = "eu-west-2"
}

variable "PATH_TO_PRIVATE_KEY" {
    description = "path to private key in local machine"
    default = "/k/DevOps/CLOUD/ariel-key.pem"
}
variable "PATH_TO_PUBLIC_KEY" {
    description = "path to public key in local machine"
    default = "ariel-key.pub"
}

variable "AMIS" {
    description  = "list of AMIS to become the OS dependent of region"
    type = map(string)
    default = {
            us-east-1    = "ami-0c7217cdde317cfec"
            eu-west-1    = "ami-0905a3c97561e0b69"
            eu-central-1 = "ami-0faab6bdbac9486fb"
            eu-west-2    = "ami-0e5f882be1900e43b"
    }
}

variable "USER_INSTANCE" {
    description = "user name of that remote machine"
    default = "ubuntu"
}