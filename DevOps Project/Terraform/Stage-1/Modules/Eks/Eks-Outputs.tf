output "Cluster-Name" {
value = aws_eks_cluster.Sprints-Eks.name
  
}
output "Cluster-EndPoint" {
  value = aws_eks_cluster.Sprints-Eks.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.Sprints-Eks.certificate_authority[0].data
}

output "Node-Group-id" {
value = aws_eks_node_group.Workers.id
}