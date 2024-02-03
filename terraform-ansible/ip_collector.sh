#!/bin/bash

# Fetch instance IPs from Terraform outputs
ANSIBLE_REMOTE_IP_PRV=$(terraform output -raw ansible_ip_prv)
MASTER_K8S_IP_PRV=$(terraform output -raw master_ip_prv)
ANSIBLE_REMOTE_IP_PUB=$(terraform output -raw ansible_ip_pub)
MASTER_K8S_IP_PUB=$(terraform output -raw master_ip_pub)

# Use SSH to configure /etc/ansible/hosts on the ansible-remote instance
# configuring and injecting ip outputs to the hosts ansible file
# checking pings
ssh -i k:/devops/cloud/ariel-key.pem ubuntu@$ANSIBLE_REMOTE_IP_PUB << EOF
sudo su - 
echo "[remote-controller]" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "ansible ansible_host=$ANSIBLE_REMOTE_IP_PRV ansible_connection=local ansible_become=true" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "[k8s_master]" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "master ansible_host=$MASTER_K8S_IP_PRV ansible_connection=ssh ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/id_rsa ansible_become=true" | sudo tee -a /etc/ansible/hosts > /dev/null

echo "[all:vars] " >> /etc/ansible/hosts 
echo "ansible_python_interpreter=/usr/bin/python3" >> /etc/ansible/hosts 
cat /etc/ansible/hosts
ansible-inventory --list -y
ssh-keyscan $ANSIBLE_REMOTE_IP_PUB >> /home/ubuntu/.ssh/known_hosts
ssh -i /home/ubuntu/.ssh/id_rsa ubuntu@$MASTER_K8S_IP_PUB
exit
ansible all -m ping
EOF
