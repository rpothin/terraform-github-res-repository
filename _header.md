# terraform-github-res-repository

[![Terraform Registry](https://img.shields.io/badge/Terraform-Registry-blue.svg)](https://registry.terraform.io/modules/rpothin/res-repository/github/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

An [AVM-aligned](https://azure.github.io/Azure-Verified-Modules/) Terraform resource module for managing GitHub repositories using the [`integrations/github`](https://registry.terraform.io/providers/integrations/github/latest/docs) provider.

## Features

- Full coverage of `github_repository` provider attributes with prescriptive, governance-aligned defaults
- Private visibility by default (secure by default)
- Template-based repository creation
- Fork-based repository creation
- Configurable merge strategies (merge commit, squash, rebase)
- GitHub Advanced Security configuration (requires GHAS license or public repo)
- Lifecycle protection: `archive_on_destroy` to prevent accidental permanent deletion

## Authentication

The module requires a GitHub token to authenticate with the GitHub API. Configure the provider in the consuming configuration:

```hcl
provider "github" {
  # Set via environment variable: GITHUB_TOKEN
  # For organizations: set GITHUB_OWNER or configure owner directly
}
```

Supported authentication methods:
- **Personal Access Token (PAT)**: set `GITHUB_TOKEN`
- **GitHub App**: configure `app_auth` block in the provider
- **GitHub Actions**: `GITHUB_TOKEN` is automatically available in Actions workflows

The token requires `repo` scope (or `public_repo` for public repositories only).

## Usage Notes

- `security_and_analysis` settings require GitHub Advanced Security (GHAS) license for private/internal repositories, or the repository must be public. Do **not** set `advanced_security` for public repositories (GitHub API rejects it).
- `gitignore_template` and `license_template` are applied **at creation time only** and have no effect on existing repositories.
- Repositories with a leading period (e.g., `.github`) are not supported by this module's name validation; create them directly with the provider.
- `vulnerability_alerts`, `pages`, and `has_downloads` are deprecated provider attributes excluded from this module. Use the dedicated `github_repository_vulnerability_alerts` and `github_repository_pages` resources instead.
