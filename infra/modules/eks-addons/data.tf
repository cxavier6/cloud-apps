data "aws_caller_identity" "current" {}

data "aws_acm_certificate" "argocd_cert" {
  domain      = "camila-devops.site"  
  most_recent = true  
  statuses    = ["ISSUED"]  
}