

Condition
    
    #no IF in terraform, so we use conditions, with ? as if and : as then true is left : and false as right to the :
    resource "aws_s3_bucket" "default" {   #true       :   false
        bucket = var.custom_name !="" ? var.custom_name: default 
        # meaning if custom_name has something it remains the same, and if its
        # empty then it installs the default
        # 
    }


Loop

    variable "users" {
        type = map(object{ is_admin = boolean})
    }

    locals {
        admin_users = {
            for name, user in var.users : name => user
            if user.is_admin
        }
    }