variable "vpc" {
  type = object({
    name = optional(string, "vpc-apps")
    cidr_block = optional(string, "10.0.0.0/24")
    internet_gateway_name = optional(string, "igw")
    public_route_table_name = optional(string, "public-route-table")
    nat_gateway_name = optional(string, "ntgw")
    private_route_table_name = optional(string, "private-route-table")
    public_subnets = optional(list(object({
      name = optional(string, "public-subnet-default")
      cidr_block = optional(string, "10.0.0.0/26")
      availability_zone = optional(string, "us-east-1a")
      map_public_ip_on_launch = optional(bool, true)
    })), [
      {
        name = "public-subnet-1a"
        cidr_block = "10.0.0.0/26"
        availability_zone = "us-east-1a"
        map_public_ip_on_launch = true
      },
      {
        name = "public-subnet-1b"
        cidr_block = "10.0.0.64/26"
        availability_zone = "us-east-1b"
        map_public_ip_on_launch = true
      }
    ])
    private_subnets = optional(list(object({
      name = optional(string, "private-subnet-default")
      cidr_block = optional(string, "10.0.0.128/26")
      availability_zone = optional(string, "us-east-1a")
      map_public_ip_on_launch = optional(bool, false)
    })), [
      {
        name = "private-subnet-1a"
        cidr_block = "10.0.0.128/26"
        availability_zone = "us-east-1a"
        map_public_ip_on_launch = false
      },
      {
        name = "private-subnet-1b"
        cidr_block = "10.0.0.192/26"
        availability_zone = "us-east-1b"
        map_public_ip_on_launch = false
      }
    ])
  })
  
  default = {}
}

variable "tags" {
  description = "Default tags for resources"
  type        = map(string)
  default     = {}
}
