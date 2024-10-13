output "jenkins_instance_id" {
  value       = aws_instance.jenkins.id
  description = "The ID of the Jenkins host instance"
}

output "public_ip" {
  value = aws_instance.jenkins.public_ip
  description = "Public ip of the machine"

} 