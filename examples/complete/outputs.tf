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

output "ssh_clone_url" {
  description = "The SSH URL to clone the repository."
  value       = module.this.ssh_clone_url
}

output "http_clone_url" {
  description = "The HTTPS URL to clone the repository."
  value       = module.this.http_clone_url
}
