
    ## instance ##
resource "aws_instance" "ansible-remote" {
    ami           = var.AMIS[var.region]
    instance_type = "t2.micro"
    subnet_id     = var.public_subnet1    
    key_name      = var.key
    tags = {
        Name = "TF-anisble-ariel-goingon"
    }
    provisioner "file" {                    # provision/copy script file for ansible deployment on instance
            source     = "ansible_module/script.sh"
            destination= "/tmp/script.sh"
    }
   
    provisioner "remote-exec" {
        inline = [                   # execute the script file
            "echo '${file("k:/devops/cloud/ariel-key.pem")}' | sudo tee -a /home/ubuntu/.ssh/id_rsa.copy > /dev/null", #FIRST, pass sensitive info
            "chmod +x /tmp/script.sh", # then apply script that uses file
            "sudo sed -i -e 's/\r$//' /tmp/script.sh", # remove the CR characters
            "sudo /tmp/script.sh",   #invoke script
        ]
    }        
    connection {                   # connect with instance
        host = coalesce(self.public_ip, self.private_ip)
        type = "ssh"
        user = "${var.INSTANCE_USERNAME}"
        private_key = file("${var.PATH_TO_PRIVATE_KEY}")
    }  
        
    
}    
   # output check for subnets and vpc id

data "aws_vpc" "existing_vpc" {
    tags = {
        Name = "ariel-vpc-project" # selecting the right VPC
    }
}

data "aws_subnets" "existing_vpc_subnets" {
     filter {
        name = "vpc-id"  # pulling the id from the selected VPC
        values = [data.aws_vpc.existing_vpc.id]
     } 
}

output "ip_ansible" {
    value = aws_instance.ansible-remote.public_ip
  }  
resource "aws_instance" "master-k8s" { # instance for cluster
    ami           = var.AMIS[var.region]
    instance_type = "t2.micro"
    subnet_id     = var.public_subnet1    
    key_name      = var.key
    tags = {
        Name = "TF-master-ariel-goingon"
    }
    provisioner "remote-exec" {
       inline = [
           "echo '*******providing pub********' ",
           "echo '${file("~/.ssh/id_rsa.pub")}' | sudo tee -a /home/ubuntu/.ssh/authorized_keys > /dev/null",    
        ]
    }
   
    connection {                   # connect with instance
        host = coalesce(self.public_ip, self.private_ip)
        type = "ssh"
        user = "${var.INSTANCE_USERNAME}"
        private_key = file("${var.PATH_TO_PRIVATE_KEY}")
    }        
   
}

output "ip_k8s_master" { #master private ip in case needed
    value = aws_instance.master-k8s.private_ip
}