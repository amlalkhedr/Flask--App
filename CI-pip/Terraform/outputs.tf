output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "jenkins_instance_id" {
  value = module.ec2.jenkins_instance_id
}


output "jenkins_sg_id" {
  value = module.security_groups.jenkins_sg_id

}

output "jenkins_public_ip" {
  value = module.ec2.public_ip
}

