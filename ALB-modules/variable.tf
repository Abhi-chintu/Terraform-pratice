variable "region" {
  type = string
  default = "ap-south-1"
}

variable "Vpc_name" {
  type = string
  default = "Demo"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_availability_zones" {
    type = list(any)
    default = ["ap-south-1a","ap-south-1b"]
}

variable "vpc_public_subnets" {
  type = list(string)
  default = [ "10.0.1.0/24","10.0.2.0/24" ]
}

variable "vpc_private_subnets" {
  type = list(any)
  default = [ "10.0.3.0/24","10.0.4.0/24" ]
}

#################Security-group variables###############################
variable "sg_name" {
  type = string
  default = "Ec2-Securitygroup"
}

################## Ec2 instance variables ##############################
variable "ami" {
    type = string
    default = "ami-0da59f1af71ea4ad2"
}

variable "key_name" {
  type = string
  default = "New_KP"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}



