resource "aws_instance" "terraform_instance" {
  count                       = 3
  ami                         = var.ami
  key_name                    = var.key_name
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id =  module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.TerraformEc2_security1.id]

  tags = {
    Name = "Instance-${count.index}"
  }

}