# this is demo for windows keys. not key-pairs like ssh

resource "aws_key_pair" "mykey" {
    key_name = "mykey-ariel"
    public_key = file("${var.PATH_TO_PUBLIC_KEY}")
}    



resource "aws_instance" "windows_example_terraForm" {
  count         = 1
  ami           = data.aws_ami.windows-ami.image_id
  instance_type = "t2.medium"
  key_name      = aws_key_pair.mykey.key_name
  user_data     = <<EOF
    <powershell> 
    net user ${var.INSTANCE_USERNAME} '${var.INSTANCE_PASSWORD}' /add /y
    net localgroup administrators ${var.INSTANCE_USERNAME} /add 

    winrm quickconfig -q
    winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
    winrm set winrm/config '@{MaxTimeoutsms="180000"}'
    winrm set winrm/config/service '@{AllowUnecnrypted="true"}'
    winrm set winrm/service/auth '@{Basic="true"}'

    netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
    netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow 
    net stop winrm
    sc.exe config winrm start=auto
    net start winrm
    </powershell>
  EOF
    
    provisioner "file" {
        source = "test.txt"
        destination = "C:/test.txt"
    }
    connection {
        host = coalesce(self.public_ip, self.private_ip)
        type = "winrm"
        timeout = "30m"
        user = "${var.INSTANCE_USERNAME}"
        password = "${var.INSTANCE_PASSWORD}"
    }
}


