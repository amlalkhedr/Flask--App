resource "aws_instance" "jenkins" {
  ami                    = var.ami
  instance_type         = var.instance_type
  subnet_id             = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name = "jenkins"
  }
}

