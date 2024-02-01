output "vpc_name" {
    value = data.aws_vpc.existing_vpc.tags["Name"]
}
output "subnets_ids" { # output all subnets
    value = data.aws_subnets.existing_vpc_subnets.ids
}
# output "server_address" {
#     value = "${aws_instance.server.0.public_dns}"
# }
output "aws_region" {
    value = var.region
}
output "ansible_ips" {
    value = aws_instance.ansible-remote.private_ip
}
output "master_ip" {
    value = aws_instance.master-k8s.private_ip
}