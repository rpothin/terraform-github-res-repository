variable "name" {
  description = <<-DESCRIPTION
  The name of the GitHub repository. Must be unique within the owner's namespace. Starts with an alphanumeric character, contains only letters, numbers, hyphens, underscores, and periods (1–100 characters). This validation is stricter than the GitHub provider default; repositories with a leading period (e.g., `.github`) must be created outside this module.
  DESCRIPTION
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]*$", var.name)) && length(var.name) >= 1 && length(var.name) <= 100
    error_message = "Repository name must be 1–100 characters, start with an alphanumeric character, and contain only letters, numbers, hyphens, underscores, and periods."
  }
}

variable "allow_auto_merge" {
  description = "Allow auto-merging pull requests when all required checks pass. Default: false (require explicit merge action)."
  type        = bool
  default     = false
  nullable    = false
}

variable "allow_forking" {
  description = "Configure private forking for organization-owned private and internal repositories. Set to `true` to enable, `false` to disable. Leave unset (null) to defer to the organization-level setting. Configuring this requires that private forking is not explicitly configured at the organization level."
  type        = bool
  default     = null
  nullable    = true
}

variable "allow_merge_commit" {
  description = "Allow merge commits for pull requests. Default: true."
  type        = bool
  default     = true
  nullable    = false
}

variable "allow_rebase_merge" {
  description = "Allow rebase merging for pull requests. Default: false (prevents complex rebase scenarios)."
  type        = bool
  default     = false
  nullable    = false
}

variable "allow_squash_merge" {
  description = "Allow squash merging for pull requests. Default: true (clean commit history)."
  type        = bool
  default     = true
  nullable    = false
}

variable "allow_update_branch" {
  description = "Always suggest updating pull request branches. Default: true (governance: keep PRs up to date with the base branch)."
  type        = bool
  default     = true
  nullable    = false
}

variable "archive_on_destroy" {
  description = "Archive the repository instead of deleting it when `terraform destroy` is run. Default: false (standard Terraform behavior — destroy deletes the repository). Set to true if you want `terraform destroy` to leave the repository archived rather than deleted. For a safer decommissioning workflow that preserves audit trail, prefer setting `lifecycle_state = \"inactive\"` and running `terraform apply` to archive the repository first, then optionally running `terraform destroy` to clean up Terraform state."
  type        = bool
  default     = false
  nullable    = false
}

variable "archived" {
  description = "Specifies if the repository should be archived (read-only). Default: false. Note: the GitHub API does not currently support unarchiving. When `lifecycle_state = \"inactive\"`, this is overridden to `true` regardless of this setting."
  type        = bool
  default     = false
  nullable    = false
}

variable "auto_init" {
  description = "Produce an initial commit with an empty README when creating the repository. Defaults to `true` when no `template` is provided, and is automatically set to `false` when `template` is set. Explicitly setting this to `true` when `template` is also set is rejected by a lifecycle precondition."
  type        = bool
  default     = null
  nullable    = true
}

variable "delete_branch_on_merge" {
  description = "Automatically delete head branches after pull requests are merged. Default: true (governance: keep repository branches clean)."
  type        = bool
  default     = true
  nullable    = false
}

variable "description" {
  description = "A short description of the repository."
  type        = string
  default     = ""
  nullable    = false
}

variable "fork" {
  description = "Create this repository as a fork of an existing repository. When true, `source_owner` and `source_repo` must both be provided (enforced by lifecycle precondition). Default: false."
  type        = bool
  default     = false
  nullable    = false
}

variable "gitignore_template" {
  description = "Use a .gitignore template when initializing the repository. Specify the template name without the extension (e.g., 'Go', 'Python', 'Node'). Applied at creation only; has no effect on existing repositories."
  type        = string
  default     = null
}

variable "has_discussions" {
  description = "Enable GitHub Discussions on the repository. Default: false (opt-in feature)."
  type        = bool
  default     = false
  nullable    = false
}

variable "has_issues" {
  description = "Enable GitHub Issues on the repository. Default: true."
  type        = bool
  default     = true
  nullable    = false
}

variable "has_projects" {
  description = "Enable GitHub Projects (classic) on the repository. Default: false. Projects v2 is managed separately. Note: may default to false if projects are disabled at the organization level."
  type        = bool
  default     = false
  nullable    = false
}

variable "has_wiki" {
  description = "Enable the GitHub Wiki on the repository. Default: false (prefer documentation inside the repository)."
  type        = bool
  default     = false
  nullable    = false
}

variable "homepage_url" {
  description = "URL of a page describing the project, displayed on the repository page."
  type        = string
  default     = null
}

variable "is_template" {
  description = "Make this repository a GitHub template repository. Default: false."
  type        = bool
  default     = false
  nullable    = false
}

variable "license_template" {
  description = "Use a license template when initializing the repository. Specify the template name without the extension (e.g., 'mit', 'apache-2.0', 'gpl-3.0'). Applied at creation only."
  type        = string
  default     = null
}

variable "lifecycle_state" {
  description = "The desired lifecycle state of the repository. `\"active\"` (default) — the repository operates normally; `var.archived` controls the archived flag directly. `\"inactive\"` — the repository is archived (read-only), overriding `var.archived`; intended for graceful decommissioning via `terraform apply` rather than `terraform destroy`. Note: archiving via the GitHub API is effectively one-way — the provider cannot unarchive a repository, so transitioning back from `\"inactive\"` to `\"active\"` will not recover the repository."
  type        = string
  default     = "active"
  nullable    = false

  validation {
    condition     = contains(["active", "inactive"], var.lifecycle_state)
    error_message = "lifecycle_state must be either \"active\" or \"inactive\"."
  }
}

variable "merge_commit_message" {
  description = "Default message for merge commits. Valid values: `PR_BODY`, `PR_TITLE`, `BLANK`. Default: `PR_TITLE`. Note: GitHub API enforces valid combinations — `MERGE_MESSAGE` title only accepts `PR_TITLE` message; `PR_TITLE` title accepts `PR_BODY` or `BLANK` message. Applicable only when `allow_merge_commit = true`."
  type        = string
  default     = "PR_TITLE"
  nullable    = false

  validation {
    condition     = contains(["PR_BODY", "PR_TITLE", "BLANK"], var.merge_commit_message)
    error_message = "merge_commit_message must be one of: PR_BODY, PR_TITLE, BLANK."
  }
}

variable "merge_commit_title" {
  description = "Default title for merge commits. Valid values: `PR_TITLE`, `MERGE_MESSAGE`. Default: `MERGE_MESSAGE`. Applicable only when `allow_merge_commit = true`."
  type        = string
  default     = "MERGE_MESSAGE"
  nullable    = false

  validation {
    condition     = contains(["PR_TITLE", "MERGE_MESSAGE"], var.merge_commit_title)
    error_message = "merge_commit_title must be one of: PR_TITLE, MERGE_MESSAGE."
  }
}

variable "security_and_analysis" {
  description = <<-DESCRIPTION
  Security and analysis settings for the repository. Requires GitHub Advanced Security (GHAS) license for private/internal repositories, or the repository must be public (security features are always enabled for public repos). Note: `advanced_security` must not be configured for public repositories (GitHub API rejects it). Each configured sub-block requires a `status` of `"enabled"` or `"disabled"`. Omit sub-blocks you do not wish to configure. Sub-blocks: `advanced_security`, `code_security`, `secret_scanning`, `secret_scanning_ai_detection`, `secret_scanning_non_provider_patterns`, `secret_scanning_push_protection`.
  Note: GitHub Dependabot vulnerability alerts are managed by the separate `github_repository_vulnerability_alerts` resource, which is not included in this module; provision it independently if needed.
  DESCRIPTION
  type = object({
    advanced_security                     = optional(object({ status = string }), null)
    code_security                         = optional(object({ status = string }), null)
    secret_scanning                       = optional(object({ status = string }), null)
    secret_scanning_ai_detection          = optional(object({ status = string }), null)
    secret_scanning_non_provider_patterns = optional(object({ status = string }), null)
    secret_scanning_push_protection       = optional(object({ status = string }), null)
  })
  default  = null
  nullable = true

  validation {
    condition = var.security_and_analysis == null ? true : alltrue([
      for feature in [
        var.security_and_analysis.advanced_security,
        var.security_and_analysis.code_security,
        var.security_and_analysis.secret_scanning,
        var.security_and_analysis.secret_scanning_ai_detection,
        var.security_and_analysis.secret_scanning_non_provider_patterns,
        var.security_and_analysis.secret_scanning_push_protection
      ] : feature == null || contains(["enabled", "disabled"], feature.status)
    ])
    error_message = "Each security_and_analysis sub-block status must be 'enabled' or 'disabled'."
  }
}

variable "source_owner" {
  description = "The GitHub organization or user that owns the repository to fork. Required when `fork = true` (enforced by lifecycle precondition)."
  type        = string
  default     = null
}

variable "source_repo" {
  description = "The name of the repository to fork. Required when `fork = true` (enforced by lifecycle precondition)."
  type        = string
  default     = null
}

variable "squash_merge_commit_message" {
  description = "Default message for squash merge commits. Valid values: `PR_BODY`, `COMMIT_MESSAGES`, `BLANK`. Default: `COMMIT_MESSAGES`. Applicable only when `allow_squash_merge = true`."
  type        = string
  default     = "COMMIT_MESSAGES"
  nullable    = false

  validation {
    condition     = contains(["PR_BODY", "COMMIT_MESSAGES", "BLANK"], var.squash_merge_commit_message)
    error_message = "squash_merge_commit_message must be one of: PR_BODY, COMMIT_MESSAGES, BLANK."
  }
}

variable "squash_merge_commit_title" {
  description = "Default title for squash merge commits. Valid values: `PR_TITLE`, `COMMIT_OR_PR_TITLE`. Default: `COMMIT_OR_PR_TITLE`. Applicable only when `allow_squash_merge = true`."
  type        = string
  default     = "COMMIT_OR_PR_TITLE"
  nullable    = false

  validation {
    condition     = contains(["PR_TITLE", "COMMIT_OR_PR_TITLE"], var.squash_merge_commit_title)
    error_message = "squash_merge_commit_title must be one of: PR_TITLE, COMMIT_OR_PR_TITLE."
  }
}

variable "template" {
  description = <<-DESCRIPTION
  Create this repository from a GitHub template repository. Mutually exclusive with `auto_init = true` (enforced by lifecycle precondition). Properties: `owner` (GitHub username or organization that owns the template), `repository` (name of the template repository), `include_all_branches` (copy all branches from the template; default: false). Note: the template repository must have the "Template repository" setting enabled on GitHub.
  DESCRIPTION
  type = object({
    owner                = string
    repository           = string
    include_all_branches = optional(bool, false)
  })
  default  = null
  nullable = true

  validation {
    condition     = var.template == null ? true : (trimspace(var.template.owner) != "" && trimspace(var.template.repository) != "")
    error_message = "template.owner and template.repository must not be empty strings when template is provided."
  }
}

variable "topics" {
  description = <<-DESCRIPTION
  A list of topics to associate with the repository. Topics improve discoverability and are displayed on the repository page. Rules: each topic must be lowercase, start with an alphanumeric character, and contain only letters, numbers, and hyphens (max 50 characters); maximum 20 topics; topics must be unique.
  DESCRIPTION
  type        = list(string)
  default     = []
  nullable    = false

  validation {
    condition     = alltrue([for topic in var.topics : can(regex("^[a-z0-9][a-z0-9-]*$", topic)) && length(topic) <= 50])
    error_message = "Each topic must be lowercase, start with an alphanumeric character, contain only letters, numbers, and hyphens, and be 50 characters or less."
  }

  validation {
    condition     = length(var.topics) <= 20
    error_message = "A maximum of 20 topics is allowed."
  }

  validation {
    condition     = length(var.topics) == length(distinct(var.topics))
    error_message = "Topics must be unique; duplicate topics are not allowed."
  }
}

variable "visibility" {
  description = "The visibility of the repository. Default: `private` (secure by default). Note: `internal` visibility requires a GitHub Enterprise account."
  type        = string
  default     = "private"
  nullable    = false

  validation {
    condition     = contains(["private", "public", "internal"], var.visibility)
    error_message = "Visibility must be one of: private, public, internal."
  }
}

variable "web_commit_signoff_required" {
  description = "Require contributors to sign off on web-based commits. Enable for DCO or compliance environments. Default: false."
  type        = bool
  default     = false
  nullable    = false
}
