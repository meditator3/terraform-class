#!/bin/bash
echo " ================ getting private IP ==================="
# extract private ip for ansible to use, using ip addr and grep
PRIVATE_IP=$(ip addr show eth0 | grep -oP 'inet \K[\d.]+')
echo $PRIVATE_IP

echo " the Private IP of the instance is: ${PRIVATE_IP}"
echo " ---------------   installing ansible ----------------------"

sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update 
sudo apt install ansible -y
sudo cp /etc/ansible/hosts /etc/ansible/hosts.original # backup original hosts
sudo mv /tmp/hosts_new /etc/ansible/hosts # replace with new hosts file
cat /etc/ansible/hosts

            # injecting the IP into the hosts of ansible
echo " --applying changes to ip--"            
sudo sed -i "s/ansible ansible_host=[0-9.]\+/ansible ansible_hosts=${PRIVATE_IP}/g" /etc/ansible/hosts
sudo echo $?
cat /etc/ansible/hosts
            # allowing keys #
sudo mv ~/.ssh/id_rsa.copy ~/.ssh/id_rsa
sudo chmod 600 id_rsa            


# echo " **** beginning python installation *****"
# sudo apt update
# sudo apt install git python3 python3-pip -y
# git clone https://github.com/kubernetes-incubator/kubespray.git
# cd kubespray
# pip install -r requirements.txt -y
