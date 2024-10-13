output "jenkins_instance_id" {
  value       = aws_instance.jenkins.id
  description = "The ID of the Jenkins host instance"
}

