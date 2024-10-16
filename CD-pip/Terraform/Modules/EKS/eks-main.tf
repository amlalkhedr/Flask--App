provider "aws" {
  region = var.region
}

# EKS Cluster definition
resource "aws_eks_cluster" "Flask-EKS" {
 name     = var.cluster_name  # Use the variable 
  role_arn = aws_iam_role.Cluster-main.arn  # Referencing the Cluster-main role
  
  # VPC Configuration with Public and Private subnets
  vpc_config {
    subnet_ids = [var.public_subnet_id, var.private_subnet_id]
  }

  # Kubernetes version
  version = "1.30"
}

# Worker nodes for EKS cluster (node group)
resource "aws_eks_node_group" "Flask-node-group" {
  cluster_name    = aws_eks_cluster.Flask-EKS.name
  node_role_arn   = aws_iam_role.WorkerNode.arn  # Updated WorkerNode role
  subnet_ids      = [var.public_subnet_id]

  scaling_config {
    desired_size = 1  # Normally 1 worker node
    max_size     = 2  # Maximum of 2 worker nodes
    min_size     = 1  # Minimum of 1 worker node
  }

  instance_types = ["t2.micro"]  # For more CPU and memory capacity
  disk_size      = 30  # Increase disk size for production workloads
  ami_type = "AL2_x86_64"  # Amazon Linux 2 (64-bit)
  
  remote_access {
    ec2_ssh_key                     = var.ssh_key_name  
    source_security_group_ids       = [var.security_group]  # Add security group here
  }

  
  # Ensure proper dependencies for worker node policies
  depends_on = [
    aws_eks_cluster.Flask-EKS,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_read_only_policy,
    aws_iam_role_policy_attachment.eks_ebs_policy  # Ensure EBS policy is included
  ]
}
