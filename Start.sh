#!/bin/bash

#Initailize terraform and apply
cd ./Terraform
terraform init
terraform apply -auto-approve

#save terraform output into a text file
terraform output > ../terraform_output.txt

# Extract the Jenkins IP from the Terraform output file
JENKINS_IP=$(grep 'jenkins_public_ip' ../terraform_output.txt | awk -F ' = ' '{print $2}' | tr -d '"')
cd ../

# Store the Jenkins IP in an environment variable
export JENKINS_IP

# Print the Jenkins IP to verify
echo "Jenkins-EC2-IP: $JENKINS_IP"

echo "[EC2s]" > "Ansible/inventory.ini"
echo "Jenkins ansible_host=${JENKINS_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/workspaces/Flask-App/Ansible/Jenkins_KP.pem" >> "Ansible/inventory.ini"

#install jenkins on ec2 
cd ./Ansible
ansible-playbook -i inventory.ini Jenkins-install-playbook.yml -K