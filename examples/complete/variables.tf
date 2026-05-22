variable "name" {
  description = "The name of the GitHub repository."
  type        = string
  default     = "example-complete"
}

variable "description" {
  description = "A short description of the repository."
  type        = string
  default     = "A complete example repository managed by Terraform."
}

variable "visibility" {
  description = "The visibility of the repository."
  type        = string
  default     = "public"
}

variable "template" {
  description = "Template repository configuration for creating the repository from a template."
  type = object({
    owner                = string
    repository           = string
    include_all_branches = optional(bool, false)
  })
  default = null
}

variable "topics" {
  description = "A list of topics to associate with the repository."
  type        = list(string)
  default     = ["terraform", "github", "infrastructure"]
}
