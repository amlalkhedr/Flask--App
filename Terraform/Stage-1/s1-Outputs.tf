output "Cluster-Name" {
value = module.Eks.Cluster-Name
  
}
output "Cluster-EndPoint" {
  value = module.Eks.Cluster-EndPoint
}

output "cluster_ca_certificate" {
  value = module.Eks.cluster_ca_certificate
}

output "Node-Group-id" {
value = module.Eks.Node-Group-id
}

output "Jenkins-IP" {
   value=aws_instance.Jenkins-EC2.public_ip
 }