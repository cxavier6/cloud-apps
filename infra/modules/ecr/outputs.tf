output "repository_arns" {
  value = [for repo in aws_ecr_repository.this : repo.arn]
}