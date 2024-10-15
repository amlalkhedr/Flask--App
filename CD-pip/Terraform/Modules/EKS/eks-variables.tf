variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  default     = "my-eks-cluster"
}

variable "public_subnet_id" {

  type        = string
}

variable "private_subnet_id" {
  type        = string
}
variable "security_group" {
  type        = string
}
variable "ssh_key_name"{
  default = "project"
}
