output "cluster_name" {
  value = aws_eks_cluster.Flask-EKS.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.Flask-EKS.endpoint
}

output "node_group_role" {
  value = aws_iam_role.eks_node_group_role.arn
}
