variable "access_key" {
    description = "AWS Acess Key"
}

variable "secret_key" {
    description = "AWS Secret Key"
}
variable "region" {
    description = "Insert your AWS region Code"
    default     = "us-east-1"
}
variable "AMIS" {
        description = "choose your AMI in context of the region"
        type = map(string)
        default = {
            us-east-1    = "ami-0c7217cdde317cfec"
            eu-west-1    = "ami-0905a3c97561e0b69"
            eu-central-1 = "ami-0faab6bdbac9486fb"
            eu-west-2    = "ami-00efc25778562c229"
        }
}
