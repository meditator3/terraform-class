
resource "aws_instance" "ariel-example" {
  count         = 1
  ami           = "${var.AMIS[var.region]}"
  instance_type = "t2.micro"
  
  provisioner "local-exec" {
    command = "echo ${aws_instance.ariel-example[0].private_ip} >> private_ip.txt"
  }
}

output "ip" {
    value = aws_instance.ariel-example[0].public_ip
  }  



