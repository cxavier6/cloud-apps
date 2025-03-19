output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnets" {
  description = "The public subnets"
  value       = aws_subnet.publics[*].id
}

output "private_subnets" {
  description = "The private subnets"
  value       = aws_subnet.privates[*].id
}
