# Configure the AWS Provider with assume role
provider "aws" {
    region = "us-east-1"
    assume_role {
        role_arn     = "arn:aws:iam::547886934166:role/TerraformRole-ca0b4b89-085b-462d-955e-08311cd335fb"
    }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
}

provider "kubectl" {
  load_config_file       = false
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version           = "client.authentication.k8s.io/v1beta1"
    args                  = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command               = "aws"
  }
  config_path            = "~/.kube/config"
}