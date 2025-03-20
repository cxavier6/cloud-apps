output "vpc_id" {
  description = "The ID of the VPC"
  value = module.vpc.vpc_id
}

output "cidr_block" {
  description = "The CIDR block of the VPC"
  value = module.vpc.cidr_block
}

output "public_subnets" {
  description = "The public subnets"
  value = module.vpc.public_subnets
}

output "private_subnets" {
  description = "The private subnets"
  value = module.vpc.private_subnets
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}


output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}
