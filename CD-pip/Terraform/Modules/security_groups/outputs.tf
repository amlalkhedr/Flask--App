output "security_group_id" {
  value       = aws_security_group.jenkins_SG.id
  description = "The ID of the jenkins security group"
}


