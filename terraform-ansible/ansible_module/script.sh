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
cat /etc/ansible/hosts
echo "" > /etc/ansible/hosts # delete text for injection of ips via ip_collector

echo " ------------ END OF ANSIBLE INSTALLATION --------------" 

            # injecting the IP into the hosts of ansible
echo " --checking changes to ip--"            

cat /etc/ansible/hosts
            # allowing keys #
echo "changing marlene on the wall"  
sudo chmod 600 ~/.ssh/id_rsa.copy          
sudo mv ~/.ssh/id_rsa.copy ~/.ssh/id_rsa
echo $? 
            


# echo " **** beginning python installation *****"
# sudo apt update
# sudo apt install git python3 python3-pip -y
# git clone https://github.com/kubernetes-incubator/kubespray.git
# cd kubespray
# pip install -r requirements.txt -y


# old scripts-great method of injecting into scripts directly
# sudo sed -i "s/ansible ansible_host=[0-9.]\+/ansible ansible_hosts=${PRIVATE_IP}/g" /etc/ansible/hosts
