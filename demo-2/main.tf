# the name after the aws_instance is just its name on its_name_in_terraForm

resource "aws_key_pair" "mykey" {
    key_name = "mykey"
    public_key = file("${var.PATH_TO_PRIVATE_KEY}")
}    



resource "aws_instance" "its_name_in_terraForm" {
    count = 1
    ami = "${var.AMIS[var.region]}"
    instance_type = "t2.micro"
    key_name      = aws_key_pair.mykey.key_name
    provisioner "file" {
            source     = "script.sh"
            destination= "/tmp/script.sh"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/script.sh",
            "sudo sed -i -e 's/\r$//' /tmp/script.sh", # remove the CR characters
            "sudo /tmp/script.sh"
        ]
    }        
    connection {
        host = coalesce(self.public_ip, self.private_ip)
        type = "ssh"
        user = "${var.INSTANCE_USERNAME}"
        private_key = file("${var.PATH_TO_PRIVATE_KEY}")
    }        
    
}


