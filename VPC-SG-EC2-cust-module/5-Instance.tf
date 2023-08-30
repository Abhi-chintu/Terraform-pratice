resource "aws_instance" "TEinstance" {
  ami                         = "ami-06f621d90fa29f6d0"
  key_name                    = "Eks-KP"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = module.vpc.public_subnet_id[0]
  vpc_security_group_ids      = [aws_security_group.SG.id]

  tags = {
    Name = "${var.project_name}-Instance"
  }

}