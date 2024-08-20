###################### AWS ACCESS KEY-PAIR #############################
resource "aws_key_pair" "my_keypair" {
  key_name   = "AWS-Access"
  public_key = file("~/.ssh/id_rsa.pub")
}


###################### JENKINS EC2 #############################

resource "aws_instance" "Jenkins-EC2" {
  ami                         = "ami-0e872aee57663ae2d"
  key_name                    = "AWS-Access"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  subnet_id                   = module.vpc.public_subnet_id
  security_groups = [
    module.vpc.security-group-id
  ]
  
  tags = {
    Name = "Jenkins"
  }

 }

###################### TERRAFORM STAGE-1 MODULES #############################

module "vpc" {
  source = "./Modules/vpc"
}

module "Eks" {
  source = "./Modules/Eks"
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  security_group = module.vpc.security-group-id
}

