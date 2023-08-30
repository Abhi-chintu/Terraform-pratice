module "vpc" {
    source = "../Module/vpc"
  
  region = var.region
  project_name = var.project_name
  cidr_block = var.cidr_block
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}