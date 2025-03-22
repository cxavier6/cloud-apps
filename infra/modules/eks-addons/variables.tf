variable "aws_lb_controller" {
    type = object({
      aws_region = optional(string, "us-east-1") 
    })
    
    default = {
      aws_region = "us-east-1"
    }
}

variable "argocd" {
  type = object({
    host = optional(string, "argocd.camila-devops.site") 
  })

  default = {}
}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "tags" {
  description = "Default tags for resources"
  type        = map(string)
  default     = {}
}