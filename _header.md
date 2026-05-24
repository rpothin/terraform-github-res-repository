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
- Lifecycle management via `lifecycle_state` for graceful, audit-trail-preserving decommissioning

## Authentication

The module requires a GitHub token to authenticate with the GitHub API. Configure the provider in the consuming configuration:

```hcl
provider "github" {
  # Set via environment variable: GITHUB_TOKEN
  # For organizations: set GITHUB_OWNER or configure owner directly
}
```

Supported authentication methods:
- **Personal Access Token (PAT)**: set `GITHUB_TOKEN` with `repo` scope (or `public_repo` for public repositories only)
- **GitHub App**: configure `app_auth` block in the provider; the app must have `Repository: Administration (write)` permission
- **GitHub Actions**: the built-in `GITHUB_TOKEN` is **not sufficient** for repository creation/management — use a PAT or GitHub App installation token stored as a separate Actions secret (see CI configuration for reference)

## Usage Notes

- `security_and_analysis` settings require GitHub Advanced Security (GHAS) license for private/internal repositories, or the repository must be public. Do **not** set `advanced_security` for public repositories (GitHub API rejects it).
- `gitignore_template` and `license_template` are applied **at creation time only** and have no effect on existing repositories.
- Repositories with a leading period (e.g., `.github`) are not supported by this module's name validation; create them directly with the provider.
- `vulnerability_alerts`, `pages`, and `has_downloads` are deprecated provider attributes excluded from this module. Use the dedicated `github_repository_vulnerability_alerts` and `github_repository_pages` resources instead.

## Lifecycle Management

This module provides a `lifecycle_state` variable for managing repository decommissioning through Terraform's normal plan/apply workflow rather than `terraform destroy`.

### Recommended decommissioning pattern

Instead of running `terraform destroy` (which deletes the repository), set `lifecycle_state = "inactive"` and apply:

```hcl
module "repo" {
  source = "rpothin/res-repository/github"

  name             = "my-repository"
  lifecycle_state  = "inactive"   # archives the repository
}
```

```bash
terraform plan   # review: archived = true
terraform apply  # archives the repository
```

This preserves the repository as a read-only archive with a complete history and audit trail. Optionally run `terraform destroy` afterwards to remove it from Terraform state (the archived repository remains on GitHub).

### Why this pattern matters

| Approach | Repository after | Audit trail | Recoverable |
|---|---|---|---|
| `terraform destroy` | **Deleted** | No | No |
| `lifecycle_state = "inactive"` + apply | **Archived** (read-only) | Yes | Manual only* |
| `archive_on_destroy = true` + destroy | **Archived** | Yes | Manual only* |

*The GitHub API does not support unarchiving repositories programmatically.

### `lifecycle_state` vs `archived`

- `archived = true` sets the archived flag directly (equivalent to `lifecycle_state = "inactive"`)
- `lifecycle_state = "inactive"` overrides `archived = false`, guaranteeing the repository is archived regardless of the `archived` variable value
- `lifecycle_state = "active"` (default) defers to `var.archived`

### `archive_on_destroy`

Set `archive_on_destroy = true` if you want `terraform destroy` to archive the repository instead of deleting it (useful as a last-resort safety net). The default is `false` — standard Terraform behavior, destroy deletes.
