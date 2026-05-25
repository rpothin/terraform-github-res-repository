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
- Lifecycle management via `archive_on_destroy` (default: `true`) and `archived` for graceful, audit-trail-preserving decommissioning

## Authentication

The module requires a GitHub token to authenticate with the GitHub API. Configure the provider in the consuming configuration:

```hcl
provider "github" {
  # Set via environment variable: GITHUB_TOKEN
  # For organizations: set GH_OWNER or configure owner directly
}
```

Supported authentication methods:
- **Personal Access Token (PAT)**: set `GITHUB_TOKEN` with `repo` scope (or `public_repo` for public repositories only). The default `archive_on_destroy = true` means `terraform destroy` only requires `repo` scope (issues `PATCH`, not `DELETE`). Add `delete_repo` scope only if you explicitly set `archive_on_destroy = false` and want destroy to fully delete the repository.
- **GitHub App**: configure `app_auth` block in the provider; the app must have `Repository: Administration (write)` permission
- **GitHub Actions**: the built-in `GITHUB_TOKEN` is **not sufficient** for repository creation/management — use a PAT or GitHub App installation token stored as a separate Actions secret (see CI configuration for reference)

## Usage Notes

- `security_and_analysis` settings require GitHub Advanced Security (GHAS) license for private/internal repositories, or the repository must be public. Do **not** set `advanced_security` for public repositories (GitHub API rejects it).
- `gitignore_template` and `license_template` are applied **at creation time only** and have no effect on existing repositories.
- Repositories with a leading period (e.g., `.github`) are not supported by this module's name validation; create them directly with the provider.
- `vulnerability_alerts`, `pages`, and `has_downloads` are deprecated provider attributes excluded from this module. Use the dedicated `github_repository_vulnerability_alerts` and `github_repository_pages` resources instead.

## Lifecycle Management

By default, `terraform destroy` **archives** the repository instead of deleting it (`archive_on_destroy = true`). This is the safe default — it preserves history and the audit trail.

### Recommended decommissioning pattern

For a clean, two-step decommission that archives the repository via a normal plan/apply cycle:

```hcl
module "repo" {
  source = "rpothin/res-repository/github"

  name     = "my-repository"
  archived = true   # archives the repository on next apply
}
```

```bash
terraform plan   # review: archived = true
terraform apply  # archives the repository (read-only, history preserved)
# Optionally: terraform destroy  # removes from Terraform state; repo stays archived on GitHub
```

### `archive_on_destroy = true` (default)

When `terraform destroy` is run, the provider issues `PATCH /repos/{owner}/{repo} {"archived": true}` instead of `DELETE`. The repository remains on GitHub as a read-only archive.

> **Name reuse note:** Because the repository is not deleted, the name remains occupied. If you need to recreate a repository with the same name, manually delete or unarchive it on GitHub first.

### When to set `archive_on_destroy = false`

Set `archive_on_destroy = false` for ephemeral repositories, test repositories, or any workflow that requires `terraform destroy` to fully free the repository name. This requires `delete_repo` scope on classic PATs.

### Why this pattern matters

| Approach | Repository after | Name freed | Audit trail | Requires `delete_repo` scope |
|---|---|---|---|---|
| `terraform destroy` (default, `archive_on_destroy = true`) | **Archived** (read-only) | No | Yes | No |
| `archived = true` + apply, then destroy | **Archived** (read-only) | No | Yes | No |
| `archive_on_destroy = false` + destroy | **Deleted** | Yes | No | Yes |

*The GitHub API does not support unarchiving repositories programmatically.
