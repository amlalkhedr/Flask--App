
# Output the Security Group ID for Jenkins
output "security_group_id" {
  value = aws_security_group.jenkins_SG.id
  description = "The Security Group ID for Jenkins worker nodes"
}

