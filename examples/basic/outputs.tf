output "resource_id" {
  description = "The unique identifier of the GitHub repository."
  value       = module.this.resource_id
}

output "name" {
  description = "The name of the GitHub repository."
  value       = module.this.name
}

output "full_name" {
  description = "The full name of the repository in the format 'owner/repository'."
  value       = module.this.full_name
}

output "html_url" {
  description = "The URL to the repository on GitHub."
  value       = module.this.html_url
}
