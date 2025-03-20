variable "eks_cluster" {
  type = object({
    cluster_name                        = optional(string, "cloud-apps")
    enabled_cluster_log_types           = optional(list(string), ["api", "audit", "authenticator", "controllerManager", "scheduler"])
    access_config_authentication_mode   = optional(string, "API_AND_CONFIG_MAP")
    ebs_csi_role                        = optional(string, "AmazonEKS_EBS_CSI_DriverRole")
    node_group = optional(object({
      name              = optional(string, "cloud-apps-ng")
      role_name         = optional(string, "cloud-apps-ng-role")
      ami_type          = optional(string, "BOTTLEROCKET_x86_64")
      instance_types    = optional(list(string), ["t3a.medium"])
      capacity_type     = optional(string, "ON_DEMAND")
      scaling_config    = optional(object({
        desired_size    = optional(number, 2)
        max_size        = optional(number, 2)
        min_size        = optional(number, 2)
      }), {
        desired_size = 2
        max_size     = 2
        min_size     = 2
      })
    }), {
      name              = "cloud-apps-ng"
      role_name         = "cloud-apps-ng-role"
      ami_type          = "BOTTLEROCKET_x86_64"
      instance_types    = ["t3.medium"]
      capacity_type     = "ON_DEMAND"
    })
  })

  default = {}
}

variable "iam" {
    type = object({
        eks_cluster_role_name = optional(string, "eks-cluster-role")
    })

    default = {}
}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnets for the EKS cluster"
  type        = list(string)
}

variable "tags" {
  description = "Default tags for resources"
  type        = map(string)
  default     = {}
}