# Configure the AWS Provider with assume role
provider "aws" {
    region = "us-east-1"
    assume_role {
        role_arn     = "arn:aws:iam::547886934166:role/TerraformRole-ca0b4b89-085b-462d-955e-08311cd335fb"
    }
}