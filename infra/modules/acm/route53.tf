data "aws_route53_zone" "this" {
  name         = "camila-devops.site"
  private_zone = false
}