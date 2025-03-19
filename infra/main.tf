# Main Terraform configuration file

# Creates VPC, Internet Gateway, NAT Gateway, Route Tables, Public and Private Subnets
module "vpc" {
  source = "./modules/vpc"

  tags = var.tags
}

module "eks" {
  depends_on = [ module.vpc ]

  source      = "./modules/eks"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets

  tags   = var.tags
}

module "ecr" {
  source = "./modules/ecr"

  tags = var.tags
}