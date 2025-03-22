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
  ecr_arns    = module.ecr.repository_arns

  tags   = var.tags
}

module "ecr" {
  source = "./modules/ecr"

  tags = var.tags
}

module "eks_addons" {
  source = "./modules/eks-addons"

  vpc_id      = module.vpc.vpc_id
  cluster_name = module.eks.cluster_name

  depends_on = [module.eks]

  tags = var.tags
}

module "acm" {
  source = "./modules/acm"

  tags = var.tags
}