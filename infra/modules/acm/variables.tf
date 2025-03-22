variable "acm" {
    type = object({
      domain_name = optional(string, "camila-devops.site") 
    })

    default = {}
}
variable "tags" {
  description = "Default tags for resources"
  type        = map(string)
  default     = {}
}