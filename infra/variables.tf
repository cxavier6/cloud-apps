variable "tags" {
  type = map(string)
  default = {
    Project     = "cloud-apps"
    Owner       = "DevOps Team"
    Environment = "Development"
  }
}

