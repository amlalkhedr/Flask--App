data "terraform_remote_state" "Stage-1" {
  backend = "local"
  config = {
    path = "../Stage-1/terraform.tfstate" # Path relative to the stage1 directory
  }
}

module"K8s"{
source = "./Modules/Kubernetes"
Cluster-Endpoint = data.terraform_remote_state.Stage-1.outputs.Cluster-EndPoint
Cluster-Name    = data.terraform_remote_state.Stage-1.outputs.Cluster-Name
Cluster-Authority= data.terraform_remote_state.Stage-1.outputs.cluster_ca_certificate
}

module"cloudWatch"{
source = "./Modules/CloudWatch"
Node-Group = data.terraform_remote_state.Stage-1.outputs.Node-Group-id
Cluster = data.terraform_remote_state.Stage-1.outputs.Cluster-Name
}