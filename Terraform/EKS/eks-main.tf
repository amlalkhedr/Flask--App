provider "aws" {
  region = var.region
}

# IAM Role for the EKS cluster (Cluster-main)
resource "aws_iam_role" "Cluster-main" {
  name = "Cluster-main"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

# EKS Cluster definition
resource "aws_eks_cluster" "Flask-EKS" {
  name     = "Flask-EKS"
  role_arn = aws_iam_role.Cluster-main.arn
  
  # VPC Configuration with Public and Private subnets
  vpc_config {
    subnet_ids = [var.public_subnet_id, var.private_subnet_id]
  }

  # Kubernetes version
  version = "1.21"
}

# Worker nodes for EKS cluster (node group)
resource "aws_eks_node_group" "Flask-node-group" {
  cluster_name    = aws_eks_cluster.Flask-EKS.name
  node_role       = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = [var.public_subnet_id, var.private_subnet_id]

  scaling_config {
    desired_size = 1  # Normally 1 worker node
    max_size     = 2  # Maximum of 2 worker nodes
    min_size     = 1  # Minimum of 1 worker node
  }

  instance_types = ["t2.micro"]
  
  remote_access {
    ec2_ssh_key = var.ssh_key_name  
  }

  depends_on = [
    aws_eks_cluster.Flask-EKS
  ]
}
