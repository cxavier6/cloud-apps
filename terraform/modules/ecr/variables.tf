variable "ecr_repository" {
    type = list(object({
        name                    = optional(string, "bar")
        image_tag_mutability    = optional(string, "MUTABLE")
    }))
    
    default = [{
        name                 = "app-node"
        image_tag_mutability = "MUTABLE"
    },
    {
        name                 = "app-python"
        image_tag_mutability = "MUTABLE"
    }
    ]
}

variable "tags" {
  description = "Default tags for resources"
  type        = map(string)
  default     = {}
}