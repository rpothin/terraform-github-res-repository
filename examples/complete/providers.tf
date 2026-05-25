terraform {
  required_version = ">= 1.9, < 2.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.12"
    }
  }
}

provider "github" {
  # Authentication via environment variable:
  #   GITHUB_TOKEN — Personal Access Token or GitHub App installation token
  # For organizations: optionally set GITHUB_OWNER to scope to the org
}
