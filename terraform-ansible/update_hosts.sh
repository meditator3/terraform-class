#!/bin/bash

# Fetch IP addresses from Terraform outputs
ANSIBLE_PUB=$(terraform output -raw ansible_ip_pub)
ansible_ip=$(terraform output -raw ansible_ip_prv)
master_ip=$(terraform output -raw master_ip_prv)
node_ip=$(terraform output -raw master_ip_pub)
file="hosts.yaml" #to reference inside the ansible 
cluster_dns="arieldevops.tech"
# transfer hosts.yaml to ansible machine
scp -i k:/devops/cloud/ariel-key.pem ./hosts.yaml ubuntu@$ANSIBLE_PUB:~/kubespray/inventory/mycluster

# updating hosts.yaml file
ssh -i k:/devops/cloud/ariel-key.pem -t ubuntu@$ANSIBLE_PUB << EOF
cd kubespray/inventory/mycluster

cp hosts.yaml hosts.yaml.bak
echo $ansible_ip
echo "Update ansible_host, ip, and access_ip for each node"

sed -i "/node1:/,/node2:/ {/ansible_host:/ s/ansible_host:.*/ansible_host: $ansible_ip/; /ip:/ s/ip:.*/ip: $ansible_ip/; /access_ip:/ s/access_ip:.*/access_ip: $ansible_ip/}" $file
sed -i "/node2:/,/node3:/ {/ansible_host:/ s/ansible_host:.*/ansible_host: $master_ip/; /ip:/ s/ip:.*/ip: $master_ip/; /access_ip:/ s/access_ip:.*/access_ip: $master_ip/}" $file
sed -i "/node3:/,/kube_control_plane:/ {/ansible_host:/ s/ansible_host:.*/ansible_host: $node_ip/; /ip:/ s/ip:.*/ip: $node_ip/; /access_ip:/ s/access_ip:.*/access_ip: $node_ip/}" $file
echo "hosts.yaml has been updated."
cd group_vars/k8s_cluster/
sed -i 's/cluster_name: cluster.local/cluster_name: $cluster_dns/' k8s-cluster.yml
echo "k8s_cluster updated"
EOF
