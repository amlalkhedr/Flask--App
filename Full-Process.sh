#!/bin/bash

#Set your Terraform directory where the main.tf file is located
TERRAFORM_DIR="./Terraform"

#Set your Ansible configuration file path 
ANSIBLE_CONFIG_FILE="./inventory.ini"

#Navigate to the Terraform directory
cd "$TERRAFORM_DIR" || exit

#Initialize Terraform 
terraform init -reconfigure

#Initialize Terraform Stage-1 
cd ./Stage-1 
terraform init 

#Apply the Terraform configuration and capture output , AUTO APPROVED 
terraform apply -auto-approve

#save terraform output into a text file 
terraform output > terraform_output.txt

# Extract the Jenkins IP from the Terraform output file
JENKINS_IP=$(grep 'Jenkins-IP' terraform_output.txt | awk -F ' = ' '{print $2}' | tr -d '"')

# Store the Jenkins IP in an environment variable
export JENKINS_IP

# Print the Jenkins IP to verify
echo "Jenkins-EC2-IP: $JENKINS_IP"

#Initialize Terraform Stage-2 
cd ../Stage-2 
terraform init -input=false

#Apply the Terraform configuration and capture output , AUTO APPROVED 
terraform apply -auto-approve

#sync the aws eks to be accessed with kubectl 
aws eks --region eu-central-1 update-kubeconfig --name Sprints-Eks

# install nexus repo on cluster
cd ../../K8s-Cluster-Files/nexus
kubectl apply -f .

#install helm charts on cluster
cd .. 
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx
helm install sprints-app ./sprints-app

#Check if the output was successfully retrieved
if [ -z "$JENKINS_IP" ]; then
    echo "Failed to retrieve Jenkins ip from Terraform."
    exit 1
fi

#Add the IP to the Ansible configuration file
echo "Adding public IP to Ansible configuration file..."

echo "[EC2s]" > "$ANSIBLE_CONFIG_FILE"
echo "Jenkins ansible_host=${JENKINS_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
" >> "$ANSIBLE_CONFIG_FILE"

#Provide feedback to the user
echo "Terraform public IP has been added to the Ansible configuration file: $ANSIBLE_CONFIG_FILE"

#install jenkins on ec2 
cd ../Ansible
ansible-playbook -i inventory.ini Jenkins-install-playbook.yml -K
#ansible-playbook -i inventory.ini 

echo "**************************************************"
echo " NOW GO INSTALL JENKINS needed plugins Manually on GUI "
echo "**************************************************"

#End of script
