# Integration tests — uses real provider, requires credentials.
#
# Prerequisites:
#   GITHUB_TOKEN  — Personal Access Token or GitHub App installation token with `repo` and `delete_repo` scopes.
#                   `delete_repo` scope is required for cleanup (terraform destroy deletes the repository).
#                   In CI, sourced from repository secret GH_TOKEN.
#   GITHUB_OWNER  — (optional) GitHub organization or user to scope repository creation under.
#                   In CI, sourced from repository variable GH_OWNER.
#
# These tests create real GitHub repositories prefixed with "tftest-".
# Repositories are DELETED automatically after each test run completes (archive_on_destroy = false, the default).
# Note: if a test run fails mid-execution, orphaned repositories may need manual cleanup via the GitHub UI or CLI.

run "creates_repository_with_required_inputs" {
  command = apply

  variables {
    name = "tftest-basic-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  }

  assert {
    condition     = startswith(output.name, "tftest-basic-") && output.html_url != ""
    error_message = "The repository should be created and expose a non-empty HTML URL."
  }
}

run "creates_repository_with_extended_config" {
  command = apply

  variables {
    name                   = "tftest-full-${formatdate("YYYYMMDDhhmmss", timestamp())}"
    description            = "Integration test repository"
    visibility             = "private"
    has_issues             = true
    topics                 = ["terraform", "testing"]
    delete_branch_on_merge = true
  }

  assert {
    condition     = startswith(output.name, "tftest-full-") && output.full_name != ""
    error_message = "The repository should be created with the extended configuration."
  }
}
