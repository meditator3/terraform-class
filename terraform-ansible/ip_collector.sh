#!/bin/bash

# Fetch instance IPs from Terraform outputs
ANSIBLE_REMOTE_IP=$(terraform output -raw ansible_ip)
MASTER_K8S_IP=$(terraform output -raw master_ip)

# Use SSH to configure /etc/ansible/hosts on the ansible-remote instance
ssh -i k:/devops/cloud/ariel-key.pem ubuntu@$ANSIBLE_REMOTE_IP << EOF
echo "[remote-controller]" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "ansible ansible_host=$ANSIBLE_REMOTE_IP ansible_connection=local ansible_become=true" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "[k8s_master]" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "master ansible_host=$MASTER_K8S_IP ansible_connection=ssh ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/id_rsa ansible_become=true" | sudo tee -a /etc/ansible/hosts > /dev/null
sudo su -
echo "[all:vars] " >> /etc/ansible/hosts 
echo "ansible_python_interpreter=/usr/bin/python3" >> /etc/ansible/hosts 
cat /etc/ansible/hosts
ansible-inventory --list -y
ssh -i /home/ubuntu/.ssh/id_rsa ubuntu@$MASTER_K8S_IP
exit
ansible all -m ping
EOF
