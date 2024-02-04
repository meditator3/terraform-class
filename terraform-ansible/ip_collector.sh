#!/bin/bash

# Fetch instance IPs from Terraform outputs
ANSIBLE_REMOTE_IP_PRV=$(terraform output -raw ansible_ip_prv)
MASTER_K8S_IP_PRV=$(terraform output -raw master_ip_prv)
ANSIBLE_REMOTE_IP_PUB=$(terraform output -raw ansible_ip_pub)
MASTER_K8S_IP_PUB=$(terraform output -raw master_ip_pub)

# Use SSH to configure /etc/ansible/hosts on the ansible-remote instance
# configuring and injecting ip outputs to the hosts ansible file
# checking pings
ssh -i k:/devops/cloud/ariel-key.pem -t ubuntu@$ANSIBLE_REMOTE_IP_PUB << EOF
echo " starting injection of IPs to hosts ansible"
echo "[remote-controller]" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "ansible ansible_host=$ANSIBLE_REMOTE_IP_PRV ansible_connection=local ansible_ssh_private_key_file=/home/ubuntu/.ssh/id_rsa ansible_become=true" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "[k8s_master]" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "master ansible_host=$MASTER_K8S_IP_PRV ansible_connection=ssh ansible_user=ubuntu  ansible_become=true" | sudo tee -a /etc/ansible/hosts > /dev/null
sudo cp /home/ubuntu/.ssh/id_rsa /root/.ssh/id_rsa
echo -e "[defaults]\ninventory=./hosts" | sudo tee -a /etc/ansible/ansible.cfg

echo "copied something"
echo "[all:vars] " | sudo tee -a /etc/ansible/hosts 
echo "ansible_python_interpreter=/usr/bin/python3" | sudo tee -a /etc/ansible/hosts 
cat /etc/ansible/hosts
ansible-inventory --list -y

whoami
sudo ansible remote-controller -m ping
sudo ansible k8s_master -m ping 
exit
EOF
