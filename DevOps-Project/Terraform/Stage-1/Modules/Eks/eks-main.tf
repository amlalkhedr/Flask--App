# Create the EKS Cluster
resource "aws_eks_cluster" "Sprints-Eks" {
  name     = "Sprints-Eks"
  role_arn  = aws_iam_role.Cluster-Manager.arn
  vpc_config {
    subnet_ids = [var.public_subnet_id,var.private_subnet_id]

  }
  
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
  ]
}

# Create the EKS Node Group with 2 Nodes
resource "aws_eks_node_group" "Workers" {
  cluster_name    = aws_eks_cluster.Sprints-Eks.name
  version = "1.30"
  node_group_name = "Workers-node-group"
  node_role_arn   = aws_iam_role.worker.arn 
  subnet_ids      = [var.public_subnet_id] 
  capacity_type   = "ON_DEMAND"
  disk_size       = "20"
  instance_types  = ["t2.large"]   # change type  
  ami_type = "AL2_x86_64"

  remote_access {
    ec2_ssh_key               = "AWS-Access"
    source_security_group_ids = [var.security_group]
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    
  ]

}
