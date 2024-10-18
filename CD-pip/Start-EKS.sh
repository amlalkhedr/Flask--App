cd Terraform
terraform init
terraform apply -auto-approve
cd ../K8s-files
./start_kubctl.sh