module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

name = "demo"
cidr = var.vpc_cidr_block
azs             = var.vpc_availability_zones
public_subnets  = var.vpc_public_subnets
private_subnets = var.vpc_private_subnets

enable_dns_hostnames = true
enable_dns_support   = true
manage_default_route_table = false
enable_nat_gateway = false
single_nat_gateway = false
}


