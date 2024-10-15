provider "aws" {
  region = var.region
}

module "eks" {
  source          = "./EKS"
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.21"
  subnets         = [module.vpc.public_subnet_id, module.vpc.private_subnet_id]  
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    worker_group = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1
      instance_type    = "t2.micro"
    }
  }
}
