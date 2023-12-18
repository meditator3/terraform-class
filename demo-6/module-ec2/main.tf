resource "aws_instance" "server" {
    ami             = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type   = "${var.instance_type}"
    key_name        = "${var.key_name}"
    count           = "${var.servers}"
    security_groups = ["${aws_security_group.sg-server.id}"]
    subnet_id       = "${lookup(var.subnets, count.index % var.servers)}"

    connection {
        host        = self.public_ip 
        user        = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
    }
    tags = {
        Name      = "${var.tagName}-${count.index}"
        CreatedBy = "Terraform"
    }

    provisioner "file" {
        source    = "{path.module}/shared/scripts.${lookup(var.service_conf, var.platform)}"
        destination = "/tmp/${lookup(var.service_conf, var.platform)}"
    }

    provisioner "remote-exec" {
        inline = [
            "echo ${var.servers} > /tmp/servers-count",
            "echo ${aws_instance.server.0.private_ip} > /temp/server-addr"
        ]
    }
}  

resource "aws_security_group" "sg-server" {
    name = "server_${var.platform}"
    description = "server internal traffic"
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = 0
        to_port   = 65535
        protocol  = "tcp"
        self      = true
    }
    ingress {
        from_port = 0
        to_port   = 65535
        protocol  = "udp"
        self      = true
    }
    ingress {
        from_port = 0
        to_port   = 65535
        protocol  = "udp"
        self      = true
    }

    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_blocks = "0.0.0.0/0"
    }
    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = "0.0.0.0/0"
    }
    
}