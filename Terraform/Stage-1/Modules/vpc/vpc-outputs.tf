output "public_subnet_id" {
  value = aws_subnet.publica.id 
}

output "private_subnet_id"{
    value = aws_subnet.private_subnet.id
}

output "security-group-name"{
    value = aws_security_group.Sprints_SG.name
}
output "security-group-id"{
    value = aws_security_group.Sprints_SG.id
}