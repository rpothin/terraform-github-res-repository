# trivy:ignore:GIT-0003 -- vulnerability_alerts is a deprecated provider attribute; use the dedicated github_repository_vulnerability_alerts resource instead
resource "github_repository" "this" {
  name = var.name

  allow_auto_merge            = var.allow_auto_merge
  allow_forking               = var.allow_forking
  allow_merge_commit          = var.allow_merge_commit
  allow_rebase_merge          = var.allow_rebase_merge
  allow_squash_merge          = var.allow_squash_merge
  allow_update_branch         = var.allow_update_branch
  archive_on_destroy          = var.archive_on_destroy
  archived                    = var.archived
  auto_init                   = var.template == null ? coalesce(var.auto_init, true) : false
  delete_branch_on_merge      = var.delete_branch_on_merge
  description                 = var.description
  fork                        = var.fork
  gitignore_template          = var.gitignore_template
  has_discussions             = var.has_discussions
  has_issues                  = var.has_issues
  has_projects                = var.has_projects
  has_wiki                    = var.has_wiki
  homepage_url                = var.homepage_url
  is_template                 = var.is_template
  license_template            = var.license_template
  merge_commit_message        = local.merge_commit_message
  merge_commit_title          = local.merge_commit_title
  source_owner                = var.source_owner
  source_repo                 = var.source_repo
  squash_merge_commit_message = local.squash_merge_commit_message
  squash_merge_commit_title   = local.squash_merge_commit_title
  topics                      = var.topics
  visibility                  = var.visibility
  web_commit_signoff_required = var.web_commit_signoff_required

  dynamic "security_and_analysis" {
    for_each = var.security_and_analysis != null ? [var.security_and_analysis] : []

    content {
      dynamic "advanced_security" {
        for_each = security_and_analysis.value.advanced_security != null ? [security_and_analysis.value.advanced_security] : []

        content {
          status = advanced_security.value.status
        }
      }

      dynamic "code_security" {
        for_each = security_and_analysis.value.code_security != null ? [security_and_analysis.value.code_security] : []

        content {
          status = code_security.value.status
        }
      }

      dynamic "secret_scanning" {
        for_each = security_and_analysis.value.secret_scanning != null ? [security_and_analysis.value.secret_scanning] : []

        content {
          status = secret_scanning.value.status
        }
      }

      dynamic "secret_scanning_ai_detection" {
        for_each = security_and_analysis.value.secret_scanning_ai_detection != null ? [security_and_analysis.value.secret_scanning_ai_detection] : []

        content {
          status = secret_scanning_ai_detection.value.status
        }
      }

      dynamic "secret_scanning_non_provider_patterns" {
        for_each = security_and_analysis.value.secret_scanning_non_provider_patterns != null ? [security_and_analysis.value.secret_scanning_non_provider_patterns] : []

        content {
          status = secret_scanning_non_provider_patterns.value.status
        }
      }

      dynamic "secret_scanning_push_protection" {
        for_each = security_and_analysis.value.secret_scanning_push_protection != null ? [security_and_analysis.value.secret_scanning_push_protection] : []

        content {
          status = secret_scanning_push_protection.value.status
        }
      }
    }
  }

  dynamic "template" {
    for_each = var.template != null ? [var.template] : []

    content {
      include_all_branches = template.value.include_all_branches
      owner                = template.value.owner
      repository           = template.value.repository
    }
  }

  lifecycle {
    precondition {
      condition     = !var.fork || (var.source_owner != null && trimspace(var.source_owner) != "" && var.source_repo != null && trimspace(var.source_repo) != "")
      error_message = "When fork = true, source_owner and source_repo must both be provided and non-empty."
    }

    precondition {
      condition     = !(var.template != null && var.auto_init == true)
      error_message = "auto_init cannot be explicitly set to true when template is provided; GitHub ignores auto_init when creating from a template."
    }

    precondition {
      condition     = var.allow_merge_commit || var.allow_squash_merge || var.allow_rebase_merge
      error_message = "At least one pull request merge strategy (allow_merge_commit, allow_squash_merge, or allow_rebase_merge) must be enabled."
    }

    precondition {
      condition     = !(var.visibility == "public" && var.security_and_analysis != null && var.security_and_analysis.advanced_security != null)
      error_message = "security_and_analysis.advanced_security must not be configured when visibility is 'public'; the GitHub API rejects this setting for public repositories."
    }

    precondition {
      condition     = !(var.fork && var.template != null)
      error_message = "fork and template are mutually exclusive; a repository cannot be both a fork and created from a template."
    }
  }
}
