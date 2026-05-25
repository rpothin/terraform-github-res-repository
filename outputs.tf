output "resource_id" {
  description = "The unique identifier of the GitHub repository."
  value       = github_repository.this.id
}

output "name" {
  description = "The name of the GitHub repository."
  value       = github_repository.this.name
}

output "full_name" {
  description = "The full name of the repository in the format 'owner/repository'."
  value       = github_repository.this.full_name
}

output "git_clone_url" {
  description = "The anonymous git read-only URL for the repository."
  value       = github_repository.this.git_clone_url
}

output "html_url" {
  description = "The URL to the repository on GitHub."
  value       = github_repository.this.html_url
}

output "http_clone_url" {
  description = "The HTTPS URL to clone the repository."
  value       = github_repository.this.http_clone_url
}

output "node_id" {
  description = "The GraphQL global node ID of the repository, used for GitHub's GraphQL API."
  value       = github_repository.this.node_id
}

output "primary_language" {
  description = "The primary programming language used in the repository. May be null for new or empty repositories."
  value       = github_repository.this.primary_language
}

output "repo_id" {
  description = "The numeric ID of the GitHub repository."
  value       = github_repository.this.repo_id
}

output "ssh_clone_url" {
  description = "The SSH URL to clone the repository."
  value       = github_repository.this.ssh_clone_url
}
