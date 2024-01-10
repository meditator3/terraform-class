# create a script that runs nginx and also changes the index.html

resource "aws_key_pair" "mykey" {
    key_name = "ariel-key"
    public_key = file("${var.PATH_TO_PUBLIC_KEY}") # we upload the public key to the remote machine
}

resource "aws_instance" "my_ec2" {
    count = 1
    ami = "${var.AMIS[var.region]}"
    instance_type = "t2.micro"
    key_name = aws_keypair.mykey.key_name
    provisioner "file" {
        source = "script.sh"
        destination = "/tmp/script.sh"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/script.sh",
            "sudo sed -i -e 's/\r$//' /tmp/script.sh",
            "sudo /tmp/script.sh"
        ]
    }
    connection {
        host = coalesce(self.public_ip, self.private_ip)
        type = "ssh"
        user = "${var.USER_INSTANCE}"
        private_key = file("${var.PATH_TO_PRIVATE_KEY}")
    }
}