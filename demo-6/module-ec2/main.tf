resource "aws_instance" "server" {
    
    # this looks for an ami by a format of ami, region-platform
    ami             = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    
    # instance type that the user selects for himself
    instance_type   = "${var.instance_type}"
    
    # using aws keys to access instance-as a variable?
    key_name        = "${var.key_name}"
    
    # how many server we want? via variable
    count           = "${var.servers}"
    
    # security group is a list, that's why [], by format of  a name and id-sec_group.name.id
    security_groups = ["${aws_security_group.sg-server.id}"]
    
    # searches for a subnet to apply, to distribute evenly the instances
    # the count.index is the # index of the instance. 
    # and var.servers represent the amount of total servers. ex.(3 total)
    # so instance 1: 1 % 3 = 1 > subnet-1 etc
    subnet_id       = "${lookup(var.subnets, count.index % var.servers)}"

    # connection is how you connect to the instance
    # self.public_ip is the ip of the instance/host-the address which terraform will connect
    # to the resource
    connection {
        host        = self.public_ip 

        # search for user abased on to the platform.
        user        = "${lookup(var.user, var.platform)}"

        # private is taken from a file, according to the key_path
        private_key = "${file("${var.key_path}")}"
    }
    tags = {
        # tag the server according to its index+tag name
        Name      = "${var.tagName}-${count.index}"
        CreatedBy = "Terraform"
    }

    provisioner "file" {
        # this allows a copy of scripts and files to be copied to the instance
        # so lookup is to look for service configuration(apache or something
        # else) + the platform
        source    = "${path.module}/shared/scripts.${lookup(var.service_conf, var.platform)}"

        destination = "/tmp/${lookup(var.service_conf, var.platform)}"
    }

    # connecting from remote
    provisioner "remote-exec" {
        inline = [
            # gives the ip addresses of the servers
            # and saves them into the file servers-count
            "echo ${var.servers} > /tmp/servers-count",
            # give the private ip of the first instance(0), save it server-addr
            "echo ${aws_instance.server.0.private_ip} > /temp/server-addr"
        ]
    }
}  

resource "aws_security_group" "sg-server" {
    name = "server2_${var.platform}"
    description = "server internal traffic"
    vpc_id = "${var.vpc_id}"

# ingress is like inbound rules, and egress is outbound rules-for the security group
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
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        # 0 to 0 over -1 protocol means ALL traffic
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
}