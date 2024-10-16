provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source            = "./Modules/vpc"
  region            = "us-east-1"
  cidr_block        = "10.0.0.0/16"
  public_cidr      = "10.0.1.0/24"
  private_cidr     = "10.0.2.0/24"
  # availability_zone = "us-east-1a"
}

module "security_groups" {
  source = "./Modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "EKS" {
  source = "./Modules/EKS"
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
   # Pass the security group ID to the EKS module
  security_group    = module.security_groups.security_group_id
}


