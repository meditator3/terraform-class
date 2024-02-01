#!/bin/bash

# Fetch instance IPs from Terraform outputs
ANSIBLE_REMOTE_IP=$(terraform output -raw ansible_ip)
MASTER_K8S_IP=$(terraform output -raw master_ip)

# Use SSH to configure /etc/ansible/hosts on the ansible-remote instance
ssh -i k:/devops/cloud/ariel-key.pem ubuntu@$ANSIBLE_REMOTE_IP << EOF
echo "[remote-controller]" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "ansible ansible_host=$ANSIBLE_REMOTE_IP ansible_connection=local" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "[k8s master]" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "master ansible_host=$MASTER_K8S_IP ansible_connection=ssh ansible_user=ubuntu" | sudo tee -a /etc/ansible/hosts > /dev/null
EOF
