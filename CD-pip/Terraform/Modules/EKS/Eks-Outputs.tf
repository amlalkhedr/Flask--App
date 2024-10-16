# Output for the EKS Cluster Name
output "cluster_name" {
  value = aws_eks_cluster.Flask-EKS.name
}

# Output for the EKS Cluster Endpoint
output "cluster_endpoint" {
  value = aws_eks_cluster.Flask-EKS.endpoint
}

# Output for the Worker Node Group IAM Role
output "node_group_role" {
  value = aws_iam_role.WorkerNode.arn
}

# Add the Certificate Authority for the EKS cluster (important for kubeconfig)
output "cluster_ca_certificate" {
  value = aws_eks_cluster.Flask-EKS.certificate_authority[0].data
}

# Add the Node Group ID output
output "node_group_id" {
  value = aws_eks_node_group.Flask-node-group.id
}
